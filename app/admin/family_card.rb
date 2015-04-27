require 'importers/family_card_importer'

ActiveAdmin.register FamilyCard do
  permit_params :pass_id, :first_name, :last_name, :expiration, :organization_name,
                 user_attributes: [:id, :email, :password, :password_confirmation]

 # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
 # # CONTROLLER MODIFICATIONS
 # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

  controller do
    def update
      user_attrs = params[:family_card][:user_attributes]
      if user_attrs[:password].blank? && user_attrs[:password_confirmation].blank?
        user_attrs.delete("password")
        user_attrs.delete("password_confirmation")
      end
      super
    end
  end

  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # # IMPORT
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  
  action_item(:import, only: :index) do
    link_to 'Import Family Cards', :action => :upload_family_card_csv
  end

  collection_action :upload_family_card_csv do
    render "admin/import/csv_import", locals: { import_type: :family_card }
  end

  collection_action :csv_import, :method => :post do
    begin
      if params[:family_card]
        csv = FamilyCardImporter.new(current_admin_user, params[:family_card][:file])
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
    user = resource.user
    password = user.assign_new_password
    user.update_attributes(password: password, password_confirmation: password)

    AdminMailer.reset_password(current_admin_user, user, password).deliver
    redirect_to admin_family_card_path, notice: "#{user.email} has had their password reset."
  end

  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # # INDEX
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

  index do
    selectable_column
    column :pass_id
    column :first_name
    column :last_name
    column :expiration
    column :organization_name
    column "User Email" do |fc|
      if fc.user?
        fc.user.email
      else 
        user_attrs = { user: { family_card_id: fc.id } }
        link_to("N/A - Create User", new_admin_user_path(user_attrs))
      end
    end
    actions do |fc|
      item "Reset Password", reset_password_admin_family_card_path(fc), method: :put if fc.user
    end
  end

  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # # FILTERS
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

  filter :pass_id
  filter :first_name
  filter :last_name
  filter :expiration
  filter :organization_name

  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # # SHOW PAGE
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

  show do
    attributes_table do
      row :pass_id
      row "Name" do
        [family_card.first_name, family_card.last_name].join(" ")
      end
      if family_card.user
        row "Email" do
          family_card.user.email
        end
      end
      row :expiration
      row :organization_name
    end

    if family_card.user.present?
      panel "User Data" do
        attributes_table_for family_card.user do
          row :updated_at
          row :email
          row :sign_in_count
          row :current_sign_in_at
          row :last_sign_in_at
        end
      end
    end

    if family_card.checkins.present?
      panel "Latest Checkins for #{family_card.pass_id}" do
        table_for family_card.checkins do
          column "Museum" do |checkin|
            checkin.museum.name if checkin.museum
          end
          column :number_of_adults
          column :number_of_children
          column :date
          column 'Link' do |checkin|
            link_to 'View', admin_checkin_path(checkin.id)
          end
        end
      end
    end
  end

  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # # EDIT FORM
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

  form do |f|
    f.semantic_errors *f.object.errors.keys
    
    tabs do
      tab 'Family Card Details' do
        f.inputs do
          f.input :pass_id, label: "Pass ID" if f.object.new_record?
          f.input :first_name
          f.input :last_name
          f.input :expiration, as: :datepicker
          f.input :organization_name
        end
      end

      if @resource.user?
        tab 'Related User Data' do
          f.has_many :user, heading: false, new_record: false do |u|
            u.input :email
            u.input :password
            u.input :password_confirmation
          end
        end
      end
    end

    f.actions
  end
end
