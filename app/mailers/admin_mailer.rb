class AdminMailer < ActionMailer::Base
  default from: "help@coolculturegram.org"

  def reset_password(current_user, user, password)
    @current_user, @user, @password = [current_user, user, password]

    mail :subject => "Force Password Reset for #{user.email}",
         :to => [current_user.email]
  end

  def successful_import(current_user, import_type, imported)
    @current_user, @import_type = current_user, import_type

    mail :subject => "Your #{import_type} Import Has Finished!",
         :to => [current_user.email]
  end

  def failed_import(current_user, import_type, errors)
    @current_user, @import_type = current_user, import_type
    @column_errors = errors[:column_errors]
    @missing_ids = errors[:csv_errors][:missing_ids]

    errors = errors[:csv_errors].except(:missing_ids)

    if errors.present?
      error_report_path = csv_error_report(import_type, errors)
      attachments["#{import_type}-errors.csv"] = File.read(error_report_path)
    end

    mail :subject => "Your #{import_type} Import Has Failed.",
         :to => [current_user.email]
  end

  private

  def csv_error_report(import_type, csv_errors)
    file = Tempfile.new("#{import_type}.csv")
    CSV.open(file.path, 'w') do |csv|
      csv << ["#{import_type} Identifier", "Error Type", "Message"]
      csv_errors.each do |id, errors|
        errors.each do |field, error|
          csv << [id, field, error]
        end
      end
    end

    file.path
  end
end