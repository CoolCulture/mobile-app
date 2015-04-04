require 'rails_helper'
require 'importers/family_card_importer'
include ActionDispatch::TestProcess

describe FamilyCardImporter do
  context "class methods" do
    describe ".new" do
      it "requires and returns import class type and file" do
        expect( lambda { FamilyCardImporter.new } ).to raise_error

        file = file_to_import('csvs-without-errors', 'family_cards.csv')
        csv = FamilyCardImporter.new(file)
        
        expect(csv.import_class).to eq FamilyCard
        expect(csv.filepath).to_not be nil
      end

      it "returns no errors if the csv is great" do
        file = file_to_import('csvs-without-errors', 'family_cards.csv')
        csv = FamilyCardImporter.new(file)
        
        expect(csv.errors).to be_empty
      end
    end
  end

  describe "#perform" do
    it "returns errors on the columns if there are extra or not the correct headings" do
      file = file_to_import('csvs-with-errors', 'family_cards_wrong_headers.csv')
      csv = FamilyCardImporter.new(file)
      csv.perform

      expect(csv.errors[:column_errors].count).to eq 2
    end

    it "returns no errors on the columns if there are none" do
      file = file_to_import('csvs-without-errors', 'family_cards.csv')
      csv = FamilyCardImporter.new(file)
      csv.perform

      expect(csv.errors[:column_errors]).to be nil
    end

    it "returns no results if there are errors" do
      file = file_to_import('csvs-with-errors', 'family_cards_no_pass_ids.csv')
      csv = FamilyCardImporter.new(file)
      csv.perform
      
      expect(csv.imported).to be_empty
    end

    it "returns an array of attributes if it succeeds" do
      file = file_to_import('csvs-without-errors', 'family_cards.csv')
      csv = FamilyCardImporter.new(file)
      csv.perform
      
      expect(csv.errors).to be_empty
      expect(csv.imported.count).to eq 1
      expect(csv.imported.first[:organization_name]).to eq "The Avengers"
      expect(FamilyCard.all.count).to eq 1
      expect(FamilyCard.find(99990)).to_not be_nil
    end

    it "will not import the same family card twice" do
      file = file_to_import('csvs-without-errors', 'family_cards.csv')
      csv = FamilyCardImporter.new(file)
      csv.perform
      expect(csv.errors).to be_empty
      expect(FamilyCard.all.count).to eq 1

      more_csv = FamilyCardImporter.new(file)
      more_csv.perform
      expect(more_csv.errors).to_not be_empty
      
      duplicate_pass_id_error = more_csv.errors[:csv_errors][99990][:duplicate_id]
      expect(duplicate_pass_id_error).to eq "Pass ID already exists."
      expect(FamilyCard.all.count).to eq 1
    end

    it "returns an error that shows the number of family cards without Pass IDs" do
      file = file_to_import('csvs-with-errors', 'family_cards_no_pass_ids.csv')
      csv = FamilyCardImporter.new(file)
      csv.perform

      expect(csv.errors[:csv_errors]).to_not be_empty
      expect(csv.errors[:csv_errors][:no_pass_id]).to eq 2
    end

    it "returns a list of errors associated with the Pass ID if they exist" do
      file = file_to_import('csvs-with-errors', 'family_cards_many_errors.csv')
      csv = FamilyCardImporter.new(file)
      csv.perform

      expect(csv.errors[:csv_errors]).to_not be_empty
      expect(csv.errors[:csv_errors][:no_pass_id]).to eq 1
      expect(csv.errors[:csv_errors][99999]).to include :first_name, :last_name,
                                                        :expiration, :language,
                                                        :organization_name
    end

    it "checks for duplicates within the file itself" do
      file = file_to_import('csvs-with-errors', 'family_cards_duplicate_rows.csv')
      csv = FamilyCardImporter.new(file)
      csv.perform
      
      expect(csv.errors[:csv_errors]).to_not be_empty
      expect(csv.errors[:csv_errors][99999]).to_not be_empty

      error = "This Pass ID is used more than once within your CSV. Duplicate rows are not allowed."
      duplicate_row_error = csv.errors[:csv_errors][99999][:duplicate_row]
      expect(duplicate_row_error).to eq error
    end
  end

  def file_to_import(folder, file)
    file = Rails.root.join('spec', 'fixtures', folder, file)
    fixture_file_upload(file, "text/csv")
  end
end
