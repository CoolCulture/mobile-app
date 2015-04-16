class AdminMailer < ActionMailer::Base
  default from: "help@coolculturegram.org"

  def reset_password(current_user, user, password)
    @current_user, @user, @password = [current_user, user, password]

    mail :subject => "Force Password Reset for #{user.email}",
         :to => [current_user.email]
  end

  def successful_import(current_user, import_type, imported)
    @current_user, @import_type = current_user, import_type
    @fun_facts = fun_facts
    @fun_facts[:new_record_count] = imported.count

    if import_type == User
      csv_user_report_path = csv_user_report(imported)
      attachments["user-upload-report.csv"] = File.read(csv_user_report_path)
    end

    mail :subject => "Your #{import_type} Import Has Finished!",
         :to => [current_user.email]
  end

  def failed_import(current_user, import_type, errors)
    @current_user, @import_type = current_user, import_type
    @column_errors = errors[:column_errors]
    @missing_ids = errors[:csv_errors][:missing_ids]
    @fun_facts = fun_facts
    
    errors = errors[:csv_errors].except(:missing_ids)

    if errors.present?
      error_report_path = csv_error_report(import_type, errors)
      attachments["#{import_type}-errors.csv"] = File.read(error_report_path)
    end

    mail :subject => "Your #{import_type} Import Has Failed.",
         :to => [current_user.email]
  end

  private

  def csv_user_report(imported)
    file = Tempfile.new("users.csv")
    CSV.open(file.path, 'w') do |csv|
      csv << ["Family Card ID", "Email", "Password"]
      imported.each do |attributes|
        csv << [attributes[:family_card_id],
                attributes[:email],
                attributes[:password]]
      end
    end

    file.path
  end

  def fun_facts
    {
      active_events: OneTimeActivity.count,
      total_checkins: Checkin.count,
      listed_museums: Museum.count,
      active_family_cards: FamilyCard.count
    }
  end

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