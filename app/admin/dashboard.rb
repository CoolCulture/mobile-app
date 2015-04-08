ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    columns do
      column class: 'column dashboard-panel' do
        panel "Latest Checkins" do
          ul do
            Checkin.asc(:date).limit(10).map do |checkin|
              div class: 'recent-listing' do
                span class: 'date' do
                  checkin.date.to_date.strftime('%A, %B %d')
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
                  act.date.to_date.strftime('%A, %B %d')
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
                  user.last_sign_in_at.strftime('%A, %B %d')
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
