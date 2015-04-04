class AdminMailer < ActionMailer::Base
  default from: "help@coolculturegram.org"

  def user_upload_report(user, success, errors)
    @user = user
    @errors = errors
    @success = success

    path = construct_successful_upload_report(@success)
    attachments["User Upload #{DateTime.now.to_s}.csv"] = File.read(path)
    
    mail :subject => "User Upload Report: #{DateTime.now.strftime('%B %d, %Y, %l:%M %p')}",
         :to => user.email
  end

  def reset_password(current_user, user, password)
    @current_user, @user, @password = [current_user, user, password]

    mail :subject => "Force Password Reset for #{user.email}",
         :to => [current_user.email]
  end

  def construct_successful_upload_report(success)
    file = Tempfile.new("file.csv")
    CSV.open(file.path, 'w') do |csv|
      csv << ["Pass ID", "Last Name", "Organization Name", "Email", "Password", "Is Admin?"]
      success.each do |pass_id, user|
        csv << [pass_id, user[:last_name], user[:organization_name], user[:email], user[:password], user[:admin]]
      end
    end

    file.path
  end
end