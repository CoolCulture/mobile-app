ActiveAdmin.register RecurringActivity do
  permit_params :name, :description, :museum_id, :start_time, :end_time, :schedule
  menu parent: "Activities", priority: 1

  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # # CONTROLLER MODIFICATIONS
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

  controller do
    def create
      super

      if @recurring_activity.valid?
        @recurring_activity.generate_upcoming_events.each { |attrs| OneTimeActivity.create(attrs) }
      end
    end
  end
  
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # # INDEX
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  
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

  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # # SHOW PAGE
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

  show do
    attributes_table do
      row :name
      row :description
      row :created_at
      row :schedule do |act|
        IceCube::Rule.from_yaml(act.schedule).to_s
      end
      row :start_time
      row :end_time
      row :museum do |act|
        act.museum? ? link_to(act.museum.name, admin_museum_path(act.museum)) : "N/A"
      end
    end
  end

  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # # FILTERS
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

  filter :name
  filter :created_at
  filter :museum, as: :select, collection: Museum.asc(:name)

  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # # EDIT FORM
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

  form partial: 'form'
end
