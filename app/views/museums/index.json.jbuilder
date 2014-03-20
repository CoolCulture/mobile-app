json.array!(@museums) do |museum|
  json.extract! museum, :id, :name, :phoneNumber, :address, :borough, :website, :hours, :subwayLines, :busLines
  json.url museum_url(museum, format: :json)
end
