FactoryGirl.define do
  factory :recurring_activity do
    museum { FactoryGirl.create(:museum, name: Faker::Venue.name) }
    name 'Watch the stars'
    description 'Just what it says'
    schedule "{\"interval\":1,\"until\":null,\"count\":null,\"validations\":{\"day\":[1]},\"rule_type\":\"IceCube::WeeklyRule\",\"week_start\":0}"
    active true
  end
end