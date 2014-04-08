class Museum
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Timestamps

  has_many :checkins, dependent: :delete

  field :name, type: String
  field :phoneNumber, type: String
  field :address, type: String
  field :borough, type: String
  field :siteUrl, type: String
  field :imageUrl, type: String
  field :hours, type: Array, default: []
  field :subwayLines, type: Array, default: []
  field :busLines, type: String
  field :categories, type: Array, default: []
  field :wifi, type: Boolean
  field :handicapAccessible, type: Boolean
  field :handsOnActivity, type: Boolean
  field :description, type: String
  field :freeAdmission, type: Boolean
  field :suggestedDonation, type: Boolean
  field :activity1, type: Hash, default: {}
  field :activity2, type: Hash, default: {}
  field :activity3, type: Hash, default: {}
  field :name_id, type: String, default:-> { slug }

  slug do |museum|
    Museum.slug_format(museum.name)
  end

  validates_presence_of :name, :phoneNumber, :address, :borough,
  						 :siteUrl, :imageUrl, :hours, :subwayLines, :categories

  validates_uniqueness_of :name

  before_save :remove_empty_hours, :sort_subway_lines
  before_update :assign_slug

  def self.import(file)
    options = {col_sep: "\t",
                remove_empty_values: false,
                key_mapping: {cip: :name,
                              phone: :phoneNumber,
                              location: :address,
                              website: :siteUrl,
                              subway: :subwayLines,
                              bus: :busLines,
                              photo_url: :imageUrl,
                              :"wi-fi" => :wifi,
                              wheelchair_accessible: :handicapAccessible,
                              hands_on_activity: :handsOnActivity,
                              museum_description: :description,
                              free: :freeAdmission,
                              suggested_admission: :suggestedDonation,
                              seasonal_hours: nil,
                              closed: nil,
                              wifi_notes: nil,
                              photo: nil,
                              :"updated_from_2013-2014_family_guide" => nil}
              }

    SmarterCSV.process(file, options) do |row|
      attrs = row.first

      attrs[:subwayLines] = attrs[:subwayLines].to_s.split(' ')
      attrs[:categories] = attrs[:categories].split(' ')

      hours = [attrs[:hours_1], attrs[:hours_2], attrs[:hours_3], attrs[:hours_4]]
      hours.reject!{|hour| hour == ""}
      attrs.merge!(hours: hours)
      attrs.delete(:hours_1)
      attrs.delete(:hours_2)
      attrs.delete(:hours_3)
      attrs.delete(:hours_4)

      attrs[:borough] = BOROUGHS[attrs[:borough]]

      museum = Museum.find_or_initialize_by(name_id: Museum.slug_format(attrs[:name]))
      museum.update(attrs)
    end
  end

  def sort_subway_lines
    sortedSubwayLines = []

    SUBWAY_LINES.each do |line|
      if self.subwayLines.include?(line)
        sortedSubwayLines.push(line)
        self.subwayLines = self.subwayLines - [line]
      end
    end

    sortedSubwayLines = sortedSubwayLines + self.subwayLines if !self.subwayLines.empty?

    self.subwayLines = sortedSubwayLines
  end

  SUBWAY_LINES = [
    "1", "2", "3", "4", "5", "6", "7", "A", "C", "E", "B", "D", "F", "M",
    "G", "J", "Z", "L", "S", "N", "Q", "R", "SIR"
  ]

  CATEGORIES = [
    "History", "Science", "Art"
  ]

  BOROUGHS = {"M" => "Manhattan",
              "BX" => "Bronx",
              "BK" => "Brooklyn",
              "SI" => "Staten Island",
              "Q" => "Queens"}

  def self.slug_format(name)
    name.gsub(/[^A-Za-z0-9 ]/, '').split(" ").join("-").downcase
  end

  protected
  def remove_empty_hours
    self.hours.reject!(&:empty?)
  end

  def assign_slug
    self.slugs[0] = Museum.slug_format(self.name)
    self.name_id = self.slugs[0]
  end
end
