class OneTimeActivity < Activity
  field :name, type: String
  field :description, type: String
  field :date, type: Date
  field :start_time, type: String
  field :end_time, type: String

  validates_presence_of :name, :description, :date
end
