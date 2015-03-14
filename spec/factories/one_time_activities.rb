FactoryGirl.define do
  factory :one_time_activity do
    museum { FactoryGirl.create(:museum, name: Faker::Venue.name) }
    name 'Watch the stars'
    description 'Just what it says'
    date Date.new(2014, 11, 4)
    active true
  end
end
