include IceCube

namespace :activities do
  task :deactivate_old_activities => :environment do
    puts "Deactivating the following old activities...\n\n"
    
    deactivated_activities = OneTimeActivity.deactivate_old_activities
    deactivated_activities.map { |act| "#{act.id}: #{act.name} at #{act.museum.name} on #{act.date}" }.
                           each { |act| puts act }

    puts "\nSuccessfully deactivated #{deactivated_activities.count} activities."
  end

  task :schedule_new_activities => :environment do
    puts "Scheduling new OneTimeActivities from RecurringActivities\n\n"

    Activity.recurring.each do |activity|
      new_activities = activity.generate_upcoming_events

      new_activities.each do |activity|
        one_time = OneTimeActivity.new(activity)

        if one_time.valid?
          one_time.save
          puts "Created #{one_time.name} on #{one_time.date}."
        else
          puts "Could not create #{activity[:name]}."
        end
      end
    end

    puts "\nDone."
  end
end

