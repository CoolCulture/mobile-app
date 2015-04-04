require 'importers/user_importer'

ActiveAdmin.register User do
  permit_params :family_card_id, :email, :password, :password_confirmation
  menu label: "Login Accounts", parent: "Users"

  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # # IMPORT
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  
  action_item(:index) do
    link_to 'Import Users', :action => :upload_users_csv
  end

  collection_action :upload_users_csv do
    render "admin/import/csv_import", locals: { import_type: :user }
  end

  collection_action :csv_import, method: :post do
    begin
      if params[:user]
        csv = UserImporter.new(current_admin_user, params[:user][:file])
        csv.perform
        flash[:notice] = "Your import is being processed! You'll receive an email when it's done."
      else
        flash[:error] = "Oops. Looks like you need a file."
      end
    rescue Mongoid::Errors::UnknownAttribute
      flash[:error] = 'The CSV had an invalid column. Please check that all columns are valid.'
    rescue
      flash[:error] = "Yikes. Something went wrong. The file you have chosen is either invalid
                       or the data is corrupted. Check for already existing Family Card IDs, a
                       malformed CSV, or other formatting issues."
    end

    redirect_to :action => :index
  end

  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # # RESET PASSWORD
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

  member_action :reset_password, method: :put do
    password = resource.assign_new_password
    AdminMailer.reset_password(current_admin_user, resource, password).deliver
    redirect_to admin_users_path, notice: "#{resource.email} has had their password reset."
  end
  
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # # INDEX
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

  index do
    selectable_column
    column :email
    column :sign_in_count
    column :created_at
    actions dropdown: true do |user|
      item "Reset Password", reset_password_admin_user_path(user), method: :put
    end
  end

  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # # FILTERS
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

  filter :email
  filter :created_at

  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # # EDIT FORM
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

  form do |f|
    f.semantic_errors *f.object.errors.keys
    
    f.inputs do
      f.input :family_card_id, input_html: { disabled: true }
      f.input :email
      f.input :password
      f.input :password_confirmation
    end

    f.actions
  end
end