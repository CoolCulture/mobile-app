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
  field :wifi, type: Boolean
  field :name_id, type: String, default:-> { slug }

  slug do |museum|
   museum.name.gsub(/[^A-Za-z0-9 ]/, '').split(" ").join("-").downcase
  end

  validates_presence_of :name, :phoneNumber, :address, :borough,
  						 :siteUrl, :hours, :subwayLines, :category, :wifi

  validates_uniqueness_of :name

  before_save :remove_empty_hours

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      row_hash = row.to_hash

      hours = [row_hash["hours1"], row_hash["hours2"], row_hash["hours3"], row_hash["hours4"]]
      hours.reject!{|hour| hour.nil?}

      row_hash.delete("hours1")
      row_hash.delete("hours2")
      row_hash.delete("hours3")
      row_hash.delete("hours4")

      row_hash["subwayLines"] = row_hash["subwayLines"].split
      row_hash["category"] = row_hash["category"].split

      row_hash.merge!("hours" => hours)
      Museum.create! row_hash
    end
  end

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
