json.array!(@museums) do |museum|
  json.extract! museum, :name, :phone_number, :address, :borough, :site_url, :image_url, :hours, :subway_lines, :bus_lines, :categories, :name_id, :wifi, :free_admission, :suggested_donation, :handicap_accessible, :hands_on_activity, :description

  json.url museum_url(museum, format: :json)
end
