namespace :one_time do
  task :change_expiration_date_to_march_2015 => :environment do
    puts "Updating all Family Cards to have the expiration date of March 15, 2015..."
    FamilyCard.update_all(expiration: Date.new(2015,3,15))
    puts "Done."
  end
end