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
        expect( lambda { CSVImporter.new(FamilyCard, file) } ).to raise_error
        
        admin = FactoryGirl.create(:admin_user)
        csv = CSVImporter.new(admin, FamilyCard, file)
        
        expect(csv.admin_user.email).to eq "admin@coolculture.org"
        expect(csv.import_class).to eq FamilyCard
        expect(csv.file).to_not be nil
      end

      it "saves columns from the file" do
        admin = FactoryGirl.create(:admin_user)
        file = file_to_import('csvs-without-errors', 'family_cards.csv')
        csv = CSVImporter.new(admin, FamilyCard, file)

        expect(csv.columns).to include(:first_name, :last_name)
        expect(csv.columns).to_not include(:created_at, :updated_at)
      end
    end
  end

  def file_to_import(folder, file)
    file = Rails.root.join('spec', 'fixtures', folder, file)
    fixture_file_upload(file, "text/csv")
  end
end
