ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    div class: "delayed-jobs" do
      div class: "flashes" do
        div class: "flash flash_notice" do
          Delayed::Job.all.map do |job|
            h3 do
              "An import is currently in progress."
            end

            para do
              case job.attempts
              when 0
                "It is currently still processing. Depending on how many
                 items are being imported it could take some time. You will
                 receive an email when the import is complete or has failed.
                 If you believe there is an error, please contact an
                 administrator."
              when 1
                "#{job.attempts} attempt has been made. Depending on how many
                 items are being imported it could take some time. You will
                 receive an email when the import is complete or has failed.
                 If you believe there is an error, please contact an
                 administrator."
              else
                "#{job.attempts} attempts have been made. There may be a
                 problem with imports. Please try again later or contact
                 an administrator."
              end
            end
          end
        end
      end
    end if Delayed::Job.count > 0

    columns do
      column class: 'column dashboard-panel' do
        panel "Latest Checkins" do
          ul do
            Checkin.desc(:date).limit(10).map do |checkin|
              div class: 'recent-listing' do
                span class: 'date' do
                  checkin.date.to_date.strftime('%A, %B %d, %Y')
                end
                span class: 'heading' do
                  link_to "The #{checkin.last_name} Family", admin_family_card_path(checkin.family_card)
                end
                span class: 'subheading' do
                  link_to checkin.museum.name, admin_museum_path(checkin.museum)
                end
              end
            end
          end
        end
      end

      column class: 'column dashboard-panel' do
        panel "Upcoming Events" do
          ul do
            Activity.upcoming.limit(10).map do |act|
              div class: 'recent-listing' do
                span class: 'date' do
                  act.date.to_date.strftime('%A, %B %d, %Y')
                end
                span class: 'heading' do
                  link_to(act.name, admin_one_time_activity_path(act))
                end
                span class: 'subheading' do
                  link_to act.museum.name, admin_museum_path(act.museum)
                end
              end
            end
          end
        end
      end

      column class: 'column dashboard-panel' do
        panel "Recently Logged In Users" do
          ul do
            User.recent(10).map do |user|
              div class: 'recent-listing' do
                span class: 'date' do
                  user.last_sign_in_at.strftime('%A, %B %d, %Y')
                end
                span class: 'subheading' do
                  link_to(user.email, admin_user_path(user))
                end
              end
            end
          end
        end
      end
    end
  end
end
