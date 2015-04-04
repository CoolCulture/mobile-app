require 'rails_helper'
require 'importers/user_importer'
include ActionDispatch::TestProcess

describe UserImporter do
  before :each do
    FactoryGirl.create(:family_card)
  end

  context "class methods" do
    describe ".new" do
      it "requires and returns import class type and file" do
        expect( lambda { UserImporter.new } ).to raise_error

        file = file_to_import('csvs-without-errors', 'users.csv')
        csv = UserImporter.new(file)
        
        expect(csv.import_class).to eq User
        expect(csv.file.original_filename).to eq "users.csv"
      end

      it "returns no errors if the csv is great" do
        file = file_to_import('csvs-without-errors', 'users.csv')
        csv = UserImporter.new(file)

        expect(csv.errors).to be_empty
      end

      it "returns an error that shows the number of users without an email" do
        file = file_to_import('csvs-with-errors', 'users_no_emails.csv')
        csv = UserImporter.new(file)
        
        expect(csv.errors[:csv_errors]).to_not be_empty
        expect(csv.errors[:csv_errors][:no_email]).to eq 1
      end

      it "returns a list of errors associated with the user's email if they exist" do
        FactoryGirl.create(:user, email: "tony@avengers.com",
                                  family_card_id: nil)
        
        file = file_to_import('csvs-with-errors', 'users_many_errors.csv')
        csv = UserImporter.new(file)
        
        expect(csv.errors[:csv_errors]).to_not be_empty
        expect(csv.errors[:csv_errors][:no_email]).to eq 1
        expect(csv.errors[:csv_errors]["tony@avengers.com"]).to include :family_card_id
        expect(csv.errors[:csv_errors]["bruce@avengers.com"]).to include :family_card_id
      end
    end
  end

  describe "#import" do
    it "returns no results if there are errors" do
      file = file_to_import('csvs-with-errors', 'users_no_emails.csv')
      csv = UserImporter.new(file)
      expect(csv.import).to be_empty
    end

    it "returns an array of attributes if it succeeds" do
      file = file_to_import('csvs-without-errors', 'users.csv')
      csv = UserImporter.new(file)
      results = csv.import
      
      expect(csv.errors).to be_empty
      expect(results.count).to eq 1
      expect(results.first[:email]).to eq "tony@avengers.com"
      expect(User.all.count).to eq 1
      
      the_national_museum = User.where(email: "tony@avengers.com").to_a
      expect(the_national_museum).to_not be_empty
      expect(the_national_museum.first.family_card_id).to eq 10000
    end

    it "will not import the same user twice" do
      file = file_to_import('csvs-without-errors', 'users.csv')
      csv = UserImporter.new(file)
      results = csv.import
      expect(csv.errors).to be_empty
      expect(User.all.count).to eq 1

      more_csv = UserImporter.new(file)
      more_results = more_csv.import
      expect(more_csv.errors).to_not be_empty
      
      duplicate_email_error = more_csv.errors[:csv_errors]["tony@avengers.com"][:duplicate_email]
      expect(duplicate_email_error).to eq "Email is already being used by another User."
      expect(User.all.count).to eq 1
    end


    it "checks for email and family card id duplicates within the file itself" do
      FactoryGirl.create(:family_card, pass_id: 99999, _id: 99999)
      file = file_to_import('csvs-with-errors', 'users_duplicate_rows.csv')
      csv = UserImporter.new(file)
      
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
