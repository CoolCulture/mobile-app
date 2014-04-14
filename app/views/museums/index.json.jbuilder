json.array!(@museums) do |museum|
  json.extract! museum, :id, :name, :phoneNumber, :address, :borough, :siteUrl, :imageUrl, :hours, :subwayLines, :busLines, :categories, :name_id, :wifi, :freeAdmission, :suggestedDonation, :handicapAccessible, :handsOnActivity, :description, :activity1, :activity2, :activity3
  json.url museum_url(museum, format: :json)
end