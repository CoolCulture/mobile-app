require 'rails_helper'
require 'importers/museum_importer'
include ActionDispatch::TestProcess

describe MuseumImporter do
  context "class methods" do
    describe ".new" do
      it "requires and returns import class type and file" do
        expect( lambda { MuseumImporter.new } ).to raise_error

        file = file_to_import('csvs-without-errors', 'museums.csv')
        csv = MuseumImporter.new(file)
        
        expect(csv.import_class).to eq Museum
        expect(csv.file.original_filename).to eq "museums.csv"
      end

      it "returns no errors if the csv is great" do
        file = file_to_import('csvs-without-errors', 'museums.csv')
        csv = MuseumImporter.new(file)
        
        expect(csv.errors).to be_empty
      end

      it "returns an error that shows the number of museums without a name" do
        file = file_to_import('csvs-with-errors', 'museums_no_names.csv')
        csv = MuseumImporter.new(file)
        
        expect(csv.errors[:csv_errors]).to_not be_empty
        expect(csv.errors[:csv_errors][:no_name]).to eq 1
      end

      it "returns a list of errors associated with the museum name_id if they exist" do
        file = file_to_import('csvs-with-errors', 'museums_many_errors.csv')
        csv = MuseumImporter.new(file)
        
        expect(csv.errors[:csv_errors]).to_not be_empty
        expect(csv.errors[:csv_errors][:no_name]).to eq 1
        expect(csv.errors[:csv_errors]["the-national-museum"]).to include :address, :borough,
                                                                          :site_url, :hours,
                                                                          :phone_number, :description,
                                                                          :subway_lines, :categories
      end

      it "checks for duplicates within the file itself" do
        file = file_to_import('csvs-with-errors', 'museums_duplicate_rows.csv')
        csv = MuseumImporter.new(file)
        
        expect(csv.errors[:csv_errors]).to_not be_empty
        expect(csv.errors[:csv_errors]["the-national-museum"]).to_not be_empty

        error = "This museum name is used more than once within your CSV. Duplicate rows are not allowed."
        duplicate_row_error = csv.errors[:csv_errors]["the-national-museum"][:duplicate_row]
        expect(duplicate_row_error).to eq error
      end
    end
  end

  describe "#import" do
    it "returns no results if there are errors" do
      file = file_to_import('csvs-with-errors', 'museums_no_names.csv')
      csv = MuseumImporter.new(file)
      expect(csv.import).to be_empty
    end

    it "returns an array of attributes if it succeeds" do
      file = file_to_import('csvs-without-errors', 'museums.csv')
      csv = MuseumImporter.new(file)
      results = csv.import
      
      expect(csv.errors).to be_empty
      expect(results.count).to eq 1
      expect(results.first[:name]).to eq "The National Museum"
      expect(Museum.all.count).to eq 1
      
      the_national_museum = Museum.where(name_id: "the-national-museum").to_a
      expect(the_national_museum).to_not be_empty
      expect(the_national_museum.first.name).to eq "The National Museum"
    end

    it "will not import the same user twice" do
      file = file_to_import('csvs-without-errors', 'museums.csv')
      csv = MuseumImporter.new(file)
      results = csv.import
      expect(csv.errors).to be_empty
      expect(Museum.all.count).to eq 1

      more_csv = MuseumImporter.new(file)
      more_results = more_csv.import
      expect(more_csv.errors).to_not be_empty
      
      duplicate_name_error = more_csv.errors[:csv_errors]["the-national-museum"][:duplicate_name]
      expect(duplicate_name_error).to eq "A museum with the same name already exists."
      expect(Museum.all.count).to eq 1
    end
  end

  def file_to_import(folder, file)
    file = Rails.root.join('spec', 'fixtures', folder, file)
    fixture_file_upload(file, "text/csv")
  end
end
