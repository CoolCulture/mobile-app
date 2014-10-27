class Activity
  include Mongoid::Document
  include Mongoid::Timestamps


  field :name, type: String
  field :description, type: String

  belongs_to :museum

  scope :one_time, ->(){ where(_type: "OneTimeActivity") }
  scope :upcoming, ->(date=Date.today){ OneTimeActivity.upcoming(date) }
end
