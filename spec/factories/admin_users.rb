FactoryGirl.define do
  factory :admin_user do
    email "admin@coolculture.org"
    password 'password'
    password_confirmation 'password'
  end
end
