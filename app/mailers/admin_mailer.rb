class AdminMailer < ActionMailer::Base
  default from: "help@coolculturegram.org"

  def family_card_upload_report(user, success, errors)
    @user = user
    @errors = errors
    @success = success

    path = construct_successful_upload_report(@success)
    attachments["FamilyCardUpload #{DateTime.now.to_s}.csv"] = File.read(path)
    
    mail :subject => "Family Card Upload Report: #{DateTime.now.strftime('%B %d, %Y, %l:%M %p')}",
         :to => user.email
  end

  private

  def construct_successful_upload_report(success)
    file = Tempfile.new("file.csv")
    CSV.open(file.path, 'w') do |csv|
      csv << ["First Name", "Last Name", "Pass ID", "Email", "Password"]
      success.each do |pass_id, user|
        csv << [user[:first_name], user[:last_name], pass_id, user[:email], user[:password]]
      end
    end

    file.path
  end
end