ActiveAdmin.register OneTimeActivity do
  permit_params :name, :date, :start_time, :end_time, :featured, :museum
  menu parent: "Activities"
  
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

  filter :name
  filter :date
  filter :featured
  filter :active
  filter :museum, as: :select, collection: Museum.asc(:name)

  form do |f|
    f.semantic_errors *f.object.errors.keys
    
    f.inputs do
      f.input :name
      f.input :date, as: :datepicker
      f.input :start_time, 
               as: :time_picker,
               input_html: { value: Activity.format_for_timepicker(@resource.start_time) }
      f.input :end_time,   
               as: :time_picker,
               input_html: { value: Activity.format_for_timepicker(@resource.start_time) }
      f.input :featured, as: :radio
      # f.input :museum, as: :select, collection: Museum.asc(:name)
    end
    
    f.actions
  end
end
