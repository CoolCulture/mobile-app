require 'importers/family_card_importer'

ActiveAdmin.register FamilyCard do
  permit_params :pass_id, :first_name, :last_name, :expiration, :organization_name
  menu parent: "Users"

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
  # # INDEX
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

  index do
    selectable_column
    column :pass_id
    column :first_name
    column :last_name
    column :expiration
    column :organization_name
    column "User" do |fc|
      if fc.user?
        "<span class='status_tag yes'>Yes</span>".html_safe
      else 
        link_to("<span class='status_tag no'>Create</span>".html_safe, new_admin_user_path({user: {family_card_id: fc.id}}))
      end
    end
    actions
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
