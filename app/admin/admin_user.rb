ActiveAdmin.register AdminUser, as: "Admin" do
  permit_params :email, :password, :password_confirmation
  menu label: "Admin Users", parent: "Users"

  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # # INDEX
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

  index do
    selectable_column
    column 'Name' do |admin|
      [admin.first_name, admin.last_name].join(' ')
    end
    column :title
    column :email
    column :sign_in_count
    actions
  end

  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # # SHOW PAGE
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

  show do
    attributes_table do
      row :first_name
      row :last_name
      row :title
      row :email
      row :sign_in_count
      row :current_sign_in_at
      row :last_sign_in_at
    end
  end

  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # # FILTERS
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

  filter :first_name
  filter :last_name
  filter :email
  filter :created_at
  filter :current_sign_in_at
  filter :sign_in_count

  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # # EDIT FORM
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "Admin Details" do
      f.input :first_name
      f.input :last_name
      f.input :title
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
end
