require 'importers/csv_importer'

class UserImporter < CSVImporter
  def initialize(file)
    super(User, file)
  end

  private

  def format_attributes(row)
    password = Devise.friendly_token.first(15)
    
    {
      family_card_id: row[:family_card_id],
      email: row[:email],
      password: password,
      password_confirmation: password,
      created_at: DateTime.now,
      updated_at: DateTime.now
    }
  end

  def validate_rows
    options = { row_sep: :auto, remove_empty_values: false }
    results = SmarterCSV.process(filepath, options)
    self.errors[:csv_errors] = { no_email: 0 }
    
    results.each do |row|
      id = row[:email]
      if id.blank?
        self.errors[:csv_errors][:no_email] += 1
        next
      end

      csv_errors = self.errors[:csv_errors][id] = {}
      if row[:email].blank?
        csv_errors[:email] = "Email is required." 
      else
        if User.where(email: row[:email]).to_a.present?
          csv_errors[:duplicate_email] = "Email is already being used by another User."
        end
      end
      
      if row[:family_card_id].blank?
        csv_errors[:family_card_id] = "A Family Card Pass ID is required."
      else
        if FamilyCard.where(_id: row[:family_card_id]).to_a.empty?
          csv_errors[:family_card_id] = "The Pass ID (#{row[:family_card_id]}) listed does not match an 
                                         existing Family Card's Pass ID.".gsub("\n","").squeeze(" ")
        end
      end

      duplicates_check = results.select do |other_rows|
        other_rows[:email] == id || other_rows[:family_card_id] == row[:family_card_id]
      end
      
      unless duplicates_check.count == 1
        error_string = "The email or pass id is used more than once within your CSV. Duplicate rows are not allowed."
        csv_errors[:duplicate_row] = error_string
      end

      self.errors[:csv_errors].delete(id) if self.errors[:csv_errors][id].empty?
    end

    self.errors[:csv_errors].delete(:no_email) if self.errors[:csv_errors][:no_email] == 0
    self.errors.delete(:csv_errors) if self.errors[:csv_errors].empty?
    return self.errors
  end
end