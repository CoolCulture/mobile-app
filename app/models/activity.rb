class Activity
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :description, type: String

  belongs_to :museum

  scope :one_time, ->(){ where(_type: "OneTimeActivity", active: true) }
  scope :recurring, ->(){ where(_type: "RecurringActivity", active: true) }
  scope :featured_activities, ->() do
    OneTimeActivity.featured_activities
  end
  scope :upcoming, ->(start_date=Date.today, end_date=(Date.today+35.days)) do
    OneTimeActivity.upcoming(start_date, end_date)
  end
  scope :upcoming_activities_for_museum, ->(museum_id) do
    where(_type: "OneTimeActivity", museum_id: museum_id).asc(:date).limit(5)
  end

  def self.format_for_timepicker(time)
    Time.parse(time).strftime("%H:%M:%S")
  end

  private
  def format_from_timepicker
    begin
      self.start_time = Time.parse(self.start_time).strftime("%l:%M %p").strip
      self.end_time = Time.parse(self.end_time).strftime("%l:%M %p").strip
    rescue
    end
  end
end
