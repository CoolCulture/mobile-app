class Museum
  include Mongoid::Document
  field :name, type: String
  field :phoneNumber, type: String
  field :address, type: String
  field :borough, type: String
  field :siteUrl, type: String
  field :hours, type: Array
  field :subwayLines, type: Array
  field :busLines, type: Array

  validates_presence_of :name, :phoneNumber, :address, :borough,
  						 :siteUrl, :hours, :subwayLines, :busLines

  validates_uniqueness_of :name
end
