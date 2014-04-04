FactoryGirl.define do
  factory :checkin do
    museum { FactoryGirl.create(:museum) }
    family_card { FactoryGirl.build(:family_card) }
    number_of_children 2
    number_of_adults 3
    date Date.new(2014, 6, 5)
    last_name 'Cooling'
  end
end
