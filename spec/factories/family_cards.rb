FactoryGirl.define do
  factory :family_card do
    first_name 'John'
    last_name 'Smith'
    pass_id 10000
    id 10000
    expiration Date.new(2020, 1, 1)
    organization_name 'BlueRidge Foundation'
    language 'en'
  end
end
