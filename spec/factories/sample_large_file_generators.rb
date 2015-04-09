CSV.open("#{Rails.root}/tmp/large_imports/museums.csv", 'w') do |csv|
  csv << ["name","phone_number","address","borough","site url","image url",
          "hours","subway lines","bus lines","additional directional info",
          "categories","wifi","handicap accessible","hands on activity",
          "description","free admission","suggested donation","twitter",
          "facebook","checkin url"]
  
  100.times do
    csv << ["#{Faker::Venue.name} #{rand(10_000)}", Faker::PhoneNumber.phone_number, 
            Faker::Address.street_address, "Brooklyn", Faker::Internet.http_url, 
            Faker::Internet.http_url, 
            "Monday: 11:00 AM - 8:00 PM, Tuesday - Friday: 10:00 AM - 9:00 PM, Saturday - Sunday: Closed",
            "A,C,D", nil, nil, 
            ["History", "Science", "Art", "Nature", "Other", "Featured"].sample([1,2,3].sample).join(','),
            [true, false].sample, [true,false].sample, [true,false].sample, Faker::Lorem.paragraph, 
            [true,false].sample, [true,false].sample, "@#{Faker::Internet.slug}",nil,nil]
  end
end

CSV.open("#{Rails.root}/tmp/large_imports/family_cards.csv", 'w') do |csv|
  csv << ['first name', 'last name', 'expiration', 'organization name', 'language', 'pass_id']
  
  10_000.times do |i|
    csv << [Faker::Name.first_name, Faker::Name.last_name, Date.new(2016,10,15),
            Faker::Company.name, 'en', (10_000 + i)]
  end
end

CSV.open("#{Rails.root}/tmp/large_imports/users.csv", 'w') do |csv|
  csv << ['email', 'family card id']
  
  10_000.times do |i|
    csv << [Faker::Internet.email, (10_000 + i)]
  end
end