ActiveAdmin.register Checkin do
  actions :all, except: :new
  menu priority: 99

  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # # INDEX
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

  index do
    selectable_column
    column 'Pass ID' do |checkin|
      checkin.family_card.pass_id
    end
    column :last_name
    column :number_of_adults
    column :number_of_children
    column :date
    actions dropdown: true, defaults: false do |checkin|
      item "View", admin_checkin_path(checkin)
      item "Delete", admin_checkin_path(checkin), method: :delete
    end
  end

  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # # FILTERS
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

  filter :last_name
  filter :number_of_adults
  filter :number_of_children
  filter :date, as: :date_range
end
