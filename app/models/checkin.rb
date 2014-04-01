class Checkin
  include Mongoid::Document

  belongs_to :museum
  belongs_to :family_card

  field :number_of_adults, type: Integer
  field :number_of_children, type: Integer

  validates_presence_of :number_of_children, :number_of_adults

end
