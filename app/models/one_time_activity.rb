class OneTimeActivity < Activity
  field :name, type: String
  field :description, type: String
  field :date, type: Date
  field :start_time, type: String
  field :end_time, type: String

  validates_presence_of :name, :description, :date

  scope :upcoming, ->(date=Date.today) do
    where(date: date...(date + 7.days)).asc(:date)
  end
end
