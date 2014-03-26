json.array!(@museums) do |museum|
  json.extract! museum, :id, :name, :phoneNumber, :address, :borough, :siteUrl, :hours, :subwayLines, :busLines, :category
  json.url museum_url(museum, format: :json)
end
