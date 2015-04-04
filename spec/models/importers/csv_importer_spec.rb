require 'rails_helper'
require 'importers/csv_importer'
include ActionDispatch::TestProcess

describe CSVImporter do
  context "general class methods" do
    describe ".new" do
      it "requires and returns import class type and file" do
        expect( lambda { CSVImporter.new } ).to raise_error
        expect( lambda { CSVImporter.new(FamilyCard) } ).to raise_error

        file = file_to_import('csvs-without-errors', 'family_cards.csv')
        csv = CSVImporter.new(FamilyCard, file)
        
        expect(csv.import_class).to eq FamilyCard
        expect(csv.file.original_filename).to eq "family_cards.csv"
      end

      it "saves columns from the file" do
        file = file_to_import('csvs-without-errors', 'family_cards.csv')
        csv = CSVImporter.new(FamilyCard, file)

        expect(csv.columns).to include(:first_name, :last_name)
        expect(csv.columns).to_not include(:created_at, :updated_at)
      end
      
      it "returns errors on the columns if there are extra or not the correct headings" do
        file = file_to_import('csvs-with-errors', 'family_cards_wrong_headers.csv')
        csv = CSVImporter.new(FamilyCard, file)

        expect(csv.errors[:column_errors].count).to eq 2
      end

      it "returns no errors on the columns if there are none" do
        file = file_to_import('csvs-without-errors', 'family_cards.csv')
        csv = CSVImporter.new(FamilyCard, file)
        expect(csv.errors[:column_errors]).to be nil
      end
    end
  end

  def file_to_import(folder, file)
    file = Rails.root.join('spec', 'fixtures', folder, file)
    fixture_file_upload(file, "text/csv")
  end
end
