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

  def reset_password(current_user, user)
    @current_user = current_user
    @user = user
    @password = assign_new_password(user)

    mail :subject => "Force Password Reset for #{user.email}",
         :to => current_user.email
  end

  private

  def assign_new_password(user)
    password = Devise.friendly_token.first(10)
    user.update_attributes(password: password, password_confirmation: password)

    password
  end

  def construct_successful_upload_report(success)
    file = Tempfile.new("file.csv")
    CSV.open(file.path, 'w') do |csv|
      csv << ["Pass ID", "Email", "Password", "Is Admin?"]
      success.each do |pass_id, user|
        csv << [pass_id, user[:email], user[:password], user[:admin]]
      end
    end

    file.path
  end
end