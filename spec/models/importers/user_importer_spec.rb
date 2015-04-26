require 'rails_helper'
require 'importers/user_importer'
include ActionDispatch::TestProcess

describe UserImporter do
  let!(:admin) { FactoryGirl.create(:admin_user) }
  
  before :each do
    FactoryGirl.create(:family_card)
  end

  context "class methods" do
    describe ".new" do
      it "requires and returns import class type and file" do
        expect( lambda { UserImporter.new } ).to raise_error

        file = file_to_import('csvs-without-errors', 'users.csv')
        csv = UserImporter.new(admin, file)
        
        expect(csv.import_class).to eq User
        expect(csv.file).to_not be nil
      end

      it "returns no errors if the csv is great" do
        file = file_to_import('csvs-without-errors', 'users.csv')
        csv = UserImporter.new(admin, file)
        csv.perform

        expect(csv.errors).to be_empty
      end

      it "returns an error that shows the number of users without an email" do
        file = file_to_import('csvs-with-errors', 'users_no_emails.csv')
        csv = UserImporter.new(admin, file)
        csv.perform
        
        expect(csv.errors[:csv_errors]).to_not be_empty
        expect(csv.errors[:csv_errors][:missing_ids]).to eq 1
      end

      it "returns a list of errors associated with the user's email if they exist" do
        file = file_to_import('csvs-with-errors', 'users_many_errors.csv')
        csv = UserImporter.new(admin, file)
        csv.perform

        expect(csv.errors[:csv_errors]).to_not be_empty
        expect(csv.errors[:csv_errors][:missing_ids]).to eq 1
        expect(csv.errors[:csv_errors]["tony@avengers.com"]).to include :family_card_id
        expect(csv.errors[:csv_errors]["bruce@avengers.com"]).to include :family_card_id
      end
    end
  end

  describe "#perform" do
    it "returns errors on the columns if there are extra or not the correct headings" do
      file = file_to_import('csvs-with-errors', 'users_wrong_headers.csv')
      csv = UserImporter.new(admin, file)
      csv.perform

      expect(csv.errors[:column_errors].count).to eq 2
    end

    it "returns no errors on the columns if there are none" do
      file = file_to_import('csvs-without-errors', 'users.csv')
      csv = UserImporter.new(admin, file)
      csv.perform

      expect(csv.errors[:column_errors]).to be nil
    end

    it "returns no results if there are errors" do
      file = file_to_import('csvs-with-errors', 'users_no_emails.csv')
      csv = UserImporter.new(admin, file)
      csv.perform

      expect(csv.imported).to be_empty
    end

    it "returns an array of attributes if it succeeds" do
      file = file_to_import('csvs-without-errors', 'users.csv')
      csv = UserImporter.new(admin, file)
      csv.perform
      
      expect(csv.errors).to be_empty
      expect(csv.imported.count).to eq 1
      expect(csv.imported.first[:email]).to eq "tony@avengers.com"
      expect(User.all.count).to eq 1
      
      user = User.where(email: "tony@avengers.com").to_a
      expect(user).to_not be_empty
      expect(user.first.family_card_id).to eq 10000
    end

    it "encrypts the password when the user is imported" do
      file = file_to_import('csvs-without-errors', 'users.csv')
      csv = UserImporter.new(admin, file)
      csv.perform
      
      expect(csv.errors).to be_empty
      expect(csv.imported.count).to eq 1
      expect(csv.imported.first[:email]).to eq "tony@avengers.com"
      expect(csv.imported.first[:password]).to_not be_blank
      
      user = User.where(email: "tony@avengers.com").to_a
      expect(user).to_not be_empty
      expect(user.first.encrypted_password).to_not be_blank
    end

    it "will not import the same user twice" do
      file = file_to_import('csvs-without-errors', 'users.csv')
      csv = UserImporter.new(admin, file)
      csv.perform

      expect(csv.errors).to be_empty
      expect(User.all.count).to eq 1

      new_file = file_to_import('csvs-without-errors', 'users.csv')
      more_csv = UserImporter.new(admin, new_file)
      more_csv.perform
      expect(more_csv.errors).to_not be_empty
      
      duplicate_email_error = more_csv.errors[:csv_errors]["tony@avengers.com"][:duplicate_email]
      expect(duplicate_email_error).to eq "Email is already being used by another User."
      expect(User.all.count).to eq 1
    end


    it "checks for email and family card id duplicates within the file itself" do
      FactoryGirl.create(:family_card, pass_id: 99999, _id: 99999)
      file = file_to_import('csvs-with-errors', 'users_duplicate_rows.csv')
      csv = UserImporter.new(admin, file)
      csv.perform

      expect(csv.errors[:csv_errors]).to_not be_empty
      expect(csv.errors[:csv_errors]["tony@avengers.com"]).to_not be_empty

      error = "The email or pass id is used more than once within your CSV. Duplicate rows are not allowed."
      duplicate_row_error = csv.errors[:csv_errors]["tony@avengers.com"][:duplicate_row]
      expect(duplicate_row_error).to eq error

      duplicate_row_error = csv.errors[:csv_errors]["bruce@avengers.com"][:duplicate_row]
      expect(duplicate_row_error).to eq error
    end
  end

  def file_to_import(folder, file)
    file = Rails.root.join('spec', 'fixtures', folder, file)
    fixture_file_upload(file, "text/csv")
  end
end
