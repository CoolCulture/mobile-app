require 'importers/csv_importer'

class FamilyCardImporter < CSVImporter
  def initialize(file)
    super(FamilyCard, file)
    validate_rows
  end

  private

  def format_attributes(row)
    {
      _id: row[:pass_id].to_i,
      pass_id: row[:pass_id].to_i,
      first_name: row[:first_name],
      last_name: row[:last_name],
      expiration: Date.parse(row[:expiration]),
      organization_name: row[:organization_name],
      language: row[:language],
      created_at: DateTime.now,
      updated_at: DateTime.now
    }
  end

  def validate_rows
    results = SmarterCSV.process(self.file, {row_sep: :auto})
    self.errors[:csv_errors] = { no_pass_id: 0 }
    
    results.each do |row|
      id = row[:pass_id]
      if id.blank?
        self.errors[:csv_errors][:no_pass_id] += 1
        next
      end

      csv_errors = self.errors[:csv_errors][id] = {}
      csv_errors[:first_name] = "First Name is required." if row[:first_name].blank?
      csv_errors[:last_name] = "Last Name is required." if row[:last_name].blank?
      
      if row[:organization_name].blank?
        csv_errors[:organization_name] = "Organization Name is required."
      end
      
      if ["en", "es"].exclude?(row[:language].downcase)
        csv_errors[:language] = "Language must be 'en' or 'es', nothing else."
      end
      
      begin
        Date.parse(row[:expiration])
      rescue
        error_string = "Expiration date is malformed. Format needs to be YYYY-MM-DD exactly."
        csv_errors[:expiration] = error_string
      end

      csv_errors[:duplicate_id] = "Pass ID already exists." if FamilyCard.where(_id: id).to_a.present?

      unless results.select { |other_rows| other_rows[:pass_id] == id }.count == 1
        error_string = "This Pass ID is used more than once within your CSV. Duplicate rows are not allowed."
        csv_errors[:duplicate_row] = error_string
      end

      self.errors[:csv_errors].delete(id) if self.errors[:csv_errors][id].empty?
    end

    self.errors[:csv_errors].delete(:no_pass_id) if self.errors[:csv_errors][:no_pass_id] == 0
    self.errors.delete(:csv_errors) if self.errors[:csv_errors].empty?
    return self.errors
  end
end