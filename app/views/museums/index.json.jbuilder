json.array!(@museums) do |museum|
  json.extract! museum, :name, :phoneNumber, :address, :borough, :siteUrl, :imageUrl, :hours, :subwayLines, :busLines, :categories, :name_id, :wifi, :freeAdmission, :suggestedDonation, :handicapAccessible, :handsOnActivity, :description
  json.url museum_url(museum, format: :json)
end
