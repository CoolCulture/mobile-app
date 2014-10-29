json.array!(@days) do |day|
  json.date day[:date]
  json.activities day[:activities], partial: 'activity', as: :activity
end
