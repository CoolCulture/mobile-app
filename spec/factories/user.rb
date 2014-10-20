FactoryGirl.define do
  factory :user do
    family_card { FactoryGirl.build(:family_card) }
    email "user@gmail.com"
    password 'password'
    password_confirmation 'password'
    admin false
  end
end
