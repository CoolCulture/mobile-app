FactoryGirl.define do
  factory :recurring_activity do
    museum { FactoryGirl.create(:museum, name: FFaker::Venue.name) }
    name 'Watch the stars'
    description 'Just what it says'
    schedule "{\"interval\":1,\"until\":null,\"count\":null,\"validations\":{\"day_of_week\":{},\"day_of_month\":[11]},\"rule_type\":\"IceCube::MonthlyRule\",\"week_start\":0}"
    active true
  end
end