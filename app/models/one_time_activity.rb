class OneTimeActivity < Activity
  field :name, type: String
  field :description, type: String
  field :date, type: Date
  field :start_time, type: String
  field :end_time, type: String
  field :active, type: Boolean, default: true

  validates_presence_of :name, :description, :date

  default_scope -> { where(active: true) }

  scope :old, ->(date=Date.today) { where(:date.lt => 3.days.ago(date)) }
  scope :upcoming, ->(start_date, end_date) do
    where(date: start_date..end_date).asc(:date)
  end

  def self.deactivate_old_activities(date=Date.today)
    self.old(date).each_with_object([]) do |activity, deactivated_activities|
      activity.update_attributes(active: false)
      deactivated_activities << activity
    end
  end
end
