namespace :one_time_activities do
  task :deactivate_old_activities => :environment do
    puts "Deactivating the following old activities...\n\n"
    
    deactivated_activities = OneTimeActivity.deactivate_old_activities
    deactivated_activities.map { |act| "#{act.id}: #{act.name} at #{act.museum.name} on #{act.date}" }.
                           each { |act| puts act }

    puts "\nSuccessfully deactivated #{deactivated_activities.count} activities."
  end
end