class Activity
  include Mongoid::Document
  include Mongoid::Timestamps


  field :name, type: String
  field :description, type: String

  belongs_to :museum

  scope :one_time, ->(){ where(_type: "OneTimeActivity") }
  scope :upcoming, ->(start_date=Date.today, end_date=(Date.today+67.days)){ OneTimeActivity.upcoming(start_date, end_date) }
end
