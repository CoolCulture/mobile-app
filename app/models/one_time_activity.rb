class OneTimeActivity < Activity
  field :name, type: String
  field :description, type: String
  field :date, type: Date
  field :start_time, type: String
  field :end_time, type: String
  field :featured, type: Boolean, default: false
  field :active, type: Boolean, default: true

  belongs_to :museum
  belongs_to :recurring_activity

  validates_presence_of :name, :description, :date, :museum

  after_initialize do |act|
    act.update_attributes(featured: false) if act.featured.nil?
  end

  before_save :format_from_timepicker

  default_scope -> { where(active: true) }

  scope :old, ->(date=Date.today) { where(:date.lt => 3.days.ago(date)) }
  scope :featured_activities, ->(date=Date.today) do
    where(:date.gte => date, active: true, featured: true).asc(:date)
  end
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
