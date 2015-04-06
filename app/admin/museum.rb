require 'importers/museum_importer'

ActiveAdmin.register Museum do
  permit_params :name, :phone_number, :address, :borough, :site_url,
                :image_url, :bus_lines, :wifi, :handicap_accessible, :hands_on_activity, :description,
                :free_admission, :suggested_donation, :additional_directional_info, :twitter, :facebook,
                :checkin_url, categories: [], hours: [], subway_lines: []

  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # # IMPORT
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  
  action_item(:import, only: :index) do
    link_to 'Import Museums', :action => :upload_museums_csv
  end

  collection_action :upload_museums_csv do
    render "admin/import/csv_import", locals: { import_type: :museum }
  end

  collection_action :csv_import, :method => :post do
    begin
      if params[:museum]
        csv = MuseumImporter.new(current_admin_user, params[:museum][:file])
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
    column :name
    column "Categories" do |museum|
      museum.categories.join(", ")
    end
    column :site_url
    actions
  end

  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # # FILTERS
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

  filter :name
  filter :borough, as: :select, collection: BOROUGHS.values
  filter :categories, as: :check_boxes, collection: CATEGORIES

  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # # SHOW PAGE
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

  show do
    attributes_table do
      row :name
      row :description
      row :checkin_url do |museum|
        museum.checkin_url
      end
    end

    render 'admin/museum/show'
  end

  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # # EDIT FORM
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

  form do |f|
    f.semantic_errors *f.object.errors.keys

    tabs do 
      tab 'Location Details' do
        f.inputs do
          f.input :name
          f.input :description, as: :text, input_html: { rows: 5 }
          f.input :phone_number
          f.input :address
          f.input :borough, as: :select, collection: BOROUGHS.values
          f.input :subway_lines, as: :check_boxes, collection: SUBWAY_LINES
          f.input :bus_lines, placeholder: "eg. M2 M3 M5"
          f.input :additional_directional_info
        end
      end

      tab 'Museum Details' do
        f.inputs do
          f.input :site_url
          f.input :wifi, as: :radio
          f.input :handicap_accessible, as: :radio
          f.input :hands_on_activity, as: :radio
          f.input :free_admission, as: :radio
          f.input :suggested_donation, as: :radio
          f.input :twitter, placeholder: "eg. @coolculture"
          f.input :facebook, placeholder: "eg. CoolCulture (do not add the full link)"
          f.input :checkin_url, label: "Special Check-In URL", placeholder: "eg. http://themet.org/registration"
        end
      end
    end

    f.actions
  end
end
