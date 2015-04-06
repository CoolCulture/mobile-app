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
    column :active
    column "Museum" do |act|
      link_to act.museum.name, admin_museum_path(act.museum)
    end
    column "Recurring Activity" do |act|
      recurring = act.recurring_activity
      link_to recurring.name, admin_recurring_activity_path(recurring) if recurring
    end
    actions
  end

  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # # FILTERS
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

  filter :name
  filter :date
  filter :featured
  filter :active
  filter :museum, as: :select, collection: Museum.asc(:name)

  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # # EDIT FORM
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

  form partial: 'form'
end
