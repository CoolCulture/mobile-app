class Museum
  include Mongoid::Document
  include Mongoid::Slug
  extend BooleanHelper

  field :name, type: String
  field :phoneNumber, type: String
  field :address, type: String
  field :borough, type: String
  field :siteUrl, type: String
  field :hours, type: Array, default: []
  field :subwayLines, type: Array, default: []
  field :busLines, type: String
  field :categories, type: Array, default: []
  field :wifi, type: Boolean
  field :name_id, type: String, default:-> { slug }

  slug do |museum|
   museum.name.gsub(/[^A-Za-z0-9 ]/, '').split(" ").join("-").downcase
  end

  validates_presence_of :name, :phoneNumber, :address, :borough,
  						 :siteUrl, :hours, :subwayLines, :categories, :wifi

  validates_uniqueness_of :name

  before_save :remove_empty_hours

  def self.import(file)
    options = {col_sep: "\t",
                remove_empty_values: false,
                key_mapping: {cip: :name,
                              phone: :phoneNumber,
                              location: :address,
                              website: :siteUrl,
                              subway: :subwayLines,
                              bus: :busLines,
                              flickr_url: nil,
                              :"wi-fi" => :wifi,
                              seasonal_hours: nil,
                              closed: nil,
                              wifi_notes: nil,
                              photo: nil,
                              :"updated_from_2013-2014_family_guide" => nil}
              }

    SmarterCSV.process(file, options) do |row|
      attrs = row.first
      
      attrs[:subwayLines] = attrs[:subwayLines].split(' ')
      attrs[:categories] = attrs[:categories].split(' ')
      attrs[:wifi] = human_to_boolean(attrs[:wifi])

      hours = [attrs[:hours_1], attrs[:hours_2], attrs[:hours_3], attrs[:hours_4]]
      hours.reject!{|hour| hour == ""}
      attrs.merge!(hours: hours)
      attrs.delete(:hours_1)
      attrs.delete(:hours_2)
      attrs.delete(:hours_3)
      attrs.delete(:hours_4)

      created = Museum.create(attrs)

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
