class Checkin
  include Mongoid::Document
  include Mongoid::Slug

  slug do |checkin|
    "#{checkin.family_card.pass_id}+#{checkin.museum.name}+#{checkin.date}"
  end

  belongs_to :museum

  belongs_to :family_card
  field :last_name

  field :number_of_adults, type: Integer
  field :number_of_children, type: Integer
  field :date, type: String

  validates_presence_of :number_of_children, :number_of_adults, :date, :last_name

  validate :checkin_limit

  def checkin_limit
    if Checkin.where({ museum_id: museum_id, family_card_id: family_card_id, date: date }).exists?
      errors.add(:limit, "You can only check into this museum once per-day")
    end
  end

end
