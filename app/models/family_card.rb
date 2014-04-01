class FamilyCard
  include Mongoid::Document

  has_many :checkins, dependent: :delete

  field :last_name, type: String
  field :pass_id, type: Integer
  field :expiration, type: Date
  field :_id, type: Integer, default: ->{ pass_id }

  validates_presence_of :last_name, :pass_id

  validates_uniqueness_of :pass_id

  def valid_last_name(name)
    last_name == name ? true : false
  end

end
