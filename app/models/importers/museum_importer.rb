require 'importers/csv_importer'

class MuseumImporter < CSVImporter
  def initialize(admin_user, file)
    super(admin_user, Museum, file)
  end

  private

  def boolean_value(value)
    ["yes", "y", "t", "true"].include?(value.downcase)
  end

  def format_attributes(row)
    image = row[:image_url].present? ? row[:image_url] : DEFAULT_IMAGE

    {
      name_id: Museum.slug_format(row[:name]),
      name: row[:name],
      description: row[:description],
      phone_number: row[:phone_number],
      address: row[:address],
      borough: row[:borough],
      site_url: row[:site_url],
      image_url: image,
      hours: row[:hours].split(','),
      subway_lines: row[:subway_lines].split(','),
      bus_lines: row[:bus_lines].split(',').join(' '),
      additional_directional_info: row[:additional_directional_info],
      categories: row[:categories].split(','),
      wifi: boolean_value(row[:wifi]),
      handicap_accessible: boolean_value(row[:handicap_accessible]),
      hands_on_activity: boolean_value(row[:hands_on_activity]),
      free_admission: boolean_value(row[:free_admission]),
      suggested_donation: boolean_value(row[:suggested_donation]),
      twitter: row[:twitter],
      facebook: row[:facebook],
      checkin_url: row[:checkin_url],
      created_at: DateTime.now,
      updated_at: DateTime.now
    }
  end

  def validate_rows
    options = { row_sep: :auto, remove_empty_values: false }
    results = SmarterCSV.process(filepath, options)
    self.errors[:csv_errors] = { missing_ids: 0 }
    
    results.each do |row|
      
      if row[:name].blank?
        self.errors[:csv_errors][:missing_ids] += 1
        next
      else
        id = Museum.slug_format(row[:name])
      end

      csv_errors = self.errors[:csv_errors][id] = {}
      csv_errors[:description] = "Description is required." if row[:description].blank?
      csv_errors[:phone_number] = "Phone Number is required." if row[:phone_number].blank?
      csv_errors[:address] = "Address is required." if row[:address].blank?
      csv_errors[:site_url] = "Site URL is required." if row[:site_url].blank?
      csv_errors[:hours] = "Hours are required." if row[:hours].blank?

      if row[:borough].blank?
        csv_errors[:borough] = "Borough is required."
      else
        error_string = "Your borough must be one of the following, 
                        exactly: #{BOROUGHS.values.join(',')}".gsub("\n","").squeeze(" ")
        
        csv_errors[:borough] = error_string unless BOROUGHS.values.include?(row[:borough])
      end

      if row[:subway_lines]
        error_string = "Your subway lines are either incorrect or malformed. Ensure
                        that your subway lines are split with a comma, no spaces
                        and that they contain only the following:
                        #{SUBWAY_LINES.join(',')}".gsub("\n","").squeeze(" ")
        lines = row[:subway_lines].split(',')
        csv_errors[:subway_lines] = error_string unless (lines - SUBWAY_LINES).empty?
      end

      if row[:categories].blank?
        csv_errors[:categories] = "At least one category is required are required."
      else
        error_string = "Your categories are either incorrect or malformed. Ensure
                        that your categories are split with a comma and no spaces
                        and are only the following, exactly:
                        #{CATEGORIES.join(',')}".gsub("\n","").squeeze(" ")
        
        csv_categories = row[:categories].split(',')
        csv_errors[:categories] = error_string unless (csv_categories - CATEGORIES).empty?
      end
      
      if Museum.where(name_id: id).to_a.present?
        csv_errors[:duplicate_name] = "A museum with the same name already exists."
      end

      unless results.select { |other_rows| other_rows[:name] == row[:name] }.count == 1
        error_string = "This museum name is used more than once within your CSV.
                        Duplicate rows are not allowed.".gsub("\n","").squeeze(" ")
        csv_errors[:duplicate_row] = error_string
      end

      self.errors[:csv_errors].delete(id) if self.errors[:csv_errors][id].empty?
    end

    self.errors[:csv_errors].delete(:missing_ids) if self.errors[:csv_errors][:missing_ids] == 0
    self.errors.delete(:csv_errors) if self.errors[:csv_errors].empty?
    return self.errors
  end
end