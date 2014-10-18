FactoryGirl.define do
  factory :museum do
    name 'The Museum of Modern Art'
    name_id 'the-museum-of-modern-art'
    phone_number '(212)-455-1236'
    address '123 Fake St'
    borough 'Manhattan'
    site_url 'http://www.moma.org'
    image_url 'http://www.test.test/image.jpg'
    hours ['9AM-5PM M-F', '10AM-9PM Sat']
    subway_lines ['A','C','J','Z']
    bus_lines 'B1,B2,B7'
    categories ['Art','History']
    wifi true
    handicap_accessible true
    hands_on_activity false
    free_admission true
    suggested_donation false
    description "A Sample Description"
  end
end
