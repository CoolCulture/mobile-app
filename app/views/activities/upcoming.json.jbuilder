json.array!(@days) do |day|
  json.date day[:date]
  json.activities day[:activities], :name, :description, :date, :start_time, :end_time
end
