class CSVImporter
  attr_accessor :admin_user, :import_class, :file, :imported, :columns, :errors

  def initialize(admin_user, import_class, file)
    @admin_user, @import_class = admin_user, import_class
    @errors, @imported = {}, []
    @file = select_file(file)
    @columns = select_columns(import_class)
  end

  def perform
    load_file
    validate_columns
    validate_rows
    results = import

    if results.empty?
      AdminMailer.failed_import(admin_user, import_class, errors).deliver
    else
      AdminMailer.successful_import(admin_user, import_class, imported).deliver
    end
  end
  handle_asynchronously :perform

  private

  def select_file(file)
    PRODUCTION ? s3_upload(file) : local_path(file)
  end

  def load_file
    return self.file unless PRODUCTION
    filename = self.file

    file_contents = S3_CLIENT.get_object(bucket_name: S3_BUCKET, key: filename)[:data]
    csv_data = CSV.parse(file_contents, converters: lambda{ |v| v ? v.strip : nil })
    
    CSV.open("tmp/#{filename}", 'wb') do |csv|
      csv_data.each { |row| csv << row }
    end

    self.file = "#{Rails.root}/tmp/#{filename}"
  end

  def validate_columns
    options = { row_sep: :auto, remove_empty_values: false }
    headers = SmarterCSV.process(file, options).first.keys
    
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

  def import
    return {} if errors.present?

    imported_files = []
    options = { chunk_size: 5000, row_sep: :auto, remove_empty_values: false }

    SmarterCSV.process(file, options) do |chunk|
      attributes_chunk = chunk.map { |row| format_attributes(row) }
      imported_files << attributes_chunk
      self.import_class.collection.insert_many(attributes_chunk)
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

  def s3_upload(file)
    filename = file.original_filename
    S3_CLIENT.put_object(bucket_name: S3_BUCKET,
                         key: filename,
                         data: IO.read(file.tempfile))

    return filename
  end

  def local_path(file)
    directory = "#{Rails.root}/tmp/csv_uploads"
    FileUtils.mkdir_p(directory) unless File.directory?(directory)
    path = File.join(directory, "#{DateTime.now.to_s}-#{file.original_filename}")
    File.open(path, "wb") { |f| f.write(file.read) }
    
    return File.path(path)
  end
end