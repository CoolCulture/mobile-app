ActiveAdmin.register RecurringActivity do
  permit_params :name, :start_time, :end_time, :schedule
  menu parent: "Activities", priority: 1
  
  index do
    selectable_column
    column :name
    column :created_at
    column "Schedule" do |act|
      IceCube::Rule.from_yaml(act.schedule).to_s
    end
    column "Museum" do |act|
      link_to act.museum.name, admin_museum_path(act.museum)
    end
    actions
  end

  filter :name
  filter :created_at
  filter :museum, as: :select, collection: Museum.asc(:name)

  form do |f|
    f.semantic_errors *f.object.errors.keys

    f.inputs do
      f.input :name
      f.input :start_time, 
               as: :time_picker,
               input_html: { value: Activity.format_for_timepicker(@resource.start_time) }
      f.input :end_time,   
               as: :time_picker,
               input_html: { value: Activity.format_for_timepicker(@resource.start_time) }
      li class: "select input required", id: "recurring_activity_schedule_input" do
        f.label :schedule, class: "label", for: "recurring_activity_schedule"
        f.select_recurring :schedule, [IceCube::Rule.from_yaml(@resource.schedule)]
        # need to be able to run @resource.schedule = nil in the controller
      end
    end

    f.actions
  end
end
