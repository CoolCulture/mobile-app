class CSVImporter
  attr_accessor :import_class, :filepath, :imported, :columns, :errors

  def initialize(import_class, file)
    @errors, @imported = {}, []
    @import_class, @filepath = import_class, file.path
    @columns = select_columns(import_class)
  end

  def perform
    validate_columns
    validate_rows
    import
  end
  handle_asynchronously :perform

  private

  def import
    return {} if errors.present?

    imported_files = []
    options = { chunk_size: 5000, row_sep: :auto, remove_empty_values: false }

    SmarterCSV.process(filepath, options) do |chunk|
      attributes_chunk = chunk.map { |row| format_attributes(row) }
      imported_files << attributes_chunk
      self.import_class.collection.insert(attributes_chunk)
    end

    self.imported = imported_files.flatten
  end

  def select_columns(import_class)
    do_not_include_list = [:_id, :_slugs, :name_id, :created_at, :updated_at,
                           :encrypted_password, :reset_password_token, :reset_password_sent_at,
                           :remember_created_at, :sign_in_count, :current_sign_in_at,
                           :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, :admin]
    import_class.column_names.map(&:to_sym) - do_not_include_list
  end

  def validate_columns
    options = { row_sep: :auto, remove_empty_values: false }
    headers = SmarterCSV.process(filepath, options).first.keys
    
    if (self.columns - headers).present?
      self.errors = { column_errors: [] }
      
      (headers - self.columns).each do |err|
        errors[:column_errors] << "#{err.to_s} is not a correct column name."
      end
      
      (self.columns - headers).each do |err|
        errors[:column_errors] << "#{err.to_s} is not included in the csv."
      end
    end
  end
end