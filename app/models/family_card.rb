class FamilyCard
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :checkins, dependent: :delete
  has_one :user, dependent: :delete
  accepts_nested_attributes_for :user

  field :first_name, type: String
  field :last_name, type: String
  field :expiration, type: Date, default: EXPIRATION_DATE
  field :organization_name, type: String
  field :language, type: String, default: ->{ "en" }
  field :pass_id, type: Integer
  field :_id, type: Integer, default: ->{ pass_id }

  validates_presence_of :first_name, :last_name, :pass_id, :organization_name

  validates_uniqueness_of :pass_id
end
