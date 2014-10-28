class OneTimeActivity < Activity
  field :name, type: String
  field :description, type: String
  field :date, type: Date
  field :start_time, type: String
  field :end_time, type: String

  validates_presence_of :name, :description, :date

  scope :upcoming, ->(start_date, end_date) do
    where(date: start_date..end_date).asc(:date)
  end
end
