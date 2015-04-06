json.extract! @featured, :name, :description, :featured, :date, :start_time, :end_time

json.museum do
  json.name @featured.museum.name
  json.name_id @featured.museum.name_id
end