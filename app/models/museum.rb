class Museum
  include Mongoid::Document
  include Mongoid::Slug
  field :name, type: String
  field :phoneNumber, type: String
  field :address, type: String
  field :borough, type: String
  field :siteUrl, type: String
  field :hours, type: Array, default: []
  field :subwayLines, type: Array, default: []
  field :busLines, type: String
  field :category, type: Array, default: []
  field :name_id, type: String, default:-> { slug }

  slug do |museum|
   museum.name.gsub(/[^A-Za-z0-9 ]/, '').split(" ").join("-").downcase
  end

  validates_presence_of :name, :phoneNumber, :address, :borough,
  						 :siteUrl, :hours, :subwayLines, :category

  validates_uniqueness_of :name

  before_save :remove_empty_hours

  SUBWAY_LINES = [
    "1", "2", "3", "4", "5", "6", "7", "A", "C", "E", "B", "D", "F", "M",
    "G", "J", "Z", "N", "Q", "R", "L", "S", "SIR"
  ]

  CATEGORIES = [
    "History", "Science", "Art"
  ]

  protected
  def remove_empty_hours
    self.hours.reject!(&:empty?)
  end

end
