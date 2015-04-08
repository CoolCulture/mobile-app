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
    actions defaults: false do |checkin|
      item "View", admin_checkin_path(checkin)
      item "Delete", admin_checkin_path(checkin), method: :delete
    end
  end

  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # # SHOW PAGE
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

  show do
    attributes_table do
      row :family_card
      row :last_name
      row :number_of_adults
      row :number_of_children
      row :date
      row :museum
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
