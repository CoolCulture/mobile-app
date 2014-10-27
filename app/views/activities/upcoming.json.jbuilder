json.array!(@activities) do |activity|
  json.extract! activity, :name, :description, :date, :start_time, :end_time
end
