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

  form partial: 'form'
end
