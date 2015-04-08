ActiveAdmin.register OneTimeActivity do
  permit_params :name, :date, :description, :start_time, :end_time, :featured, :museum_id
  menu parent: "Activities"
  
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # # INDEX
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  
  index do
    selectable_column
    column :name
    column :date
    column :start_time
    column :end_time
    column :featured
    column "Museum" do |act|
      link_to act.museum.name, admin_museum_path(act.museum) if act.museum
    end
    column "Recurring Activity" do |act|
      recurring = act.recurring_activity
      link_to recurring.name, admin_recurring_activity_path(recurring) if recurring
    end
    actions
  end

  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # # SHOW PAGE
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

  show do
    attributes_table do
      row :name
      row :date
      row :start_time
      row :end_time
      row "Featured" do |act|
        act.featured ? "Yes" : "No"
      end
      row :museum
      row :recurring_activity
    end
  end

  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # # FILTERS
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

  filter :name
  filter :date
  filter :featured
  filter :museum, as: :select, collection: Museum.asc(:name)

  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # # EDIT FORM
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

  form partial: 'form'
end
