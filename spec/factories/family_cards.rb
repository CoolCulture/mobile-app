FactoryGirl.define do
  factory :family_card do
    last_name 'Cooling'
    pass_id 10000
    id 10000
    expiration Date.new(2020, 1, 1)
  end
end
