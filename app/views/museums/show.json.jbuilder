json.extract! @museum, :id, :name, :phone_number, :address, :borough, :site_url, :image_url, :hours, :subway_lines, :bus_lines, :additional_directional_info, :categories, :name_id, :wifi, :free_admission, :suggested_donation, :handicap_accessible, :hands_on_activity, :description, :activities, :checkin_url

json.featured_activities @museum.activities.upcoming.limit(10).where(featured: true), partial: 'activity', as: :activity
json.unfeatured_activities @museum.activities.upcoming.limit(10).where(featured: false), partial: 'activity', as: :activity