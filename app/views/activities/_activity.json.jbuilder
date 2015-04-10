json.extract! activity, :name, :description, :featured, :date, :start_time, :end_time

json.museum do
  json.name activity.museum.name
  json.name_id activity.museum.name_id
end
