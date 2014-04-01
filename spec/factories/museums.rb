FactoryGirl.define do
  factory :museum do
    name 'The Museum of Modern Art'
    name_id 'the-museum-of-modern-art'
    phoneNumber '(212)-455-1236'
    address '123 Fake St'
    borough 'Manhattan'
    siteUrl 'http://www.moma.org'
    hours ['9AM-5PM M-F', '10AM-9PM Sat']
    subwayLines ['A','C','J','Z']
    busLines 'B1,B2,B7'
    categories ['Art','History']
    wifi true
  end
end
