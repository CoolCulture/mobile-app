class Museum
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Timestamps

  has_many :checkins, dependent: :delete
  embeds_many :activities

  field :name, type: String
  field :phone_number, type: String
  field :address, type: String
  field :borough, type: String
  field :site_url, type: String
  field :image_url, type: String
  field :hours, type: Array, default: []
  field :subway_lines, type: Array, default: []
  field :bus_lines, type: String
  field :categories, type: Array, default: []
  field :wifi, type: Boolean
  field :handicap_accessible, type: Boolean
  field :hands_on_activity, type: Boolean
  field :description, type: String
  field :free_admission, type: Boolean
  field :suggested_donation, type: Boolean
  field :name_id, type: String, default:-> { slug }

  slug do |museum|
    Museum.slug_format(museum.name)
  end

  validates_presence_of :name, :phone_number, :address, :borough,
  						 :site_url, :image_url, :hours, :categories

  validates_uniqueness_of :name

  before_save :remove_empty_hours, :sort_subway_lines
  before_update :assign_slug

  def self.import(file)
    options = {col_sep: "\t",
                force_simple_split: true,
                remove_empty_values: false,
                key_mapping: {cip: :name,
                              phone: :phone_number,
                              location: :address,
                              website: :site_url,
                              subway: :subway_lines,
                              bus: :bus_lines,
                              photo_url: :image_url,
                              :"wi-fi" => :wifi,
                              wheelchair_accessible: :handicap_accessible,
                              hands_on_activity: :hands_on_activity,
                              museum_description: :description,
                              free: :free_admission,
                              suggested_admission: :suggested_donation,
                              seasonal_hours: nil,
                              closed: nil,
                              wifi_notes: nil,
                              photo: nil,
                              :"updated_from_2013-2014_family_guide" => nil}
              }

    errors = {}

    SmarterCSV.process(file, options) do |row|
      attrs = row.first

      attrs[:subway_lines] = attrs[:subway_lines].to_s.split(' ')
      attrs[:categories] = attrs[:categories].split(' ')

      hours = [attrs[:hours_1], attrs[:hours_2], attrs[:hours_3], attrs[:hours_4]]
      hours.reject!{|hour| hour == ""}
      attrs.merge!(hours: hours)
      attrs.delete(:hours_1)
      attrs.delete(:hours_2)
      attrs.delete(:hours_3)
      attrs.delete(:hours_4)

      attrs[:borough] = BOROUGHS[attrs[:borough]]

      name_id = Museum.slug_format(attrs[:name])
      museum = Museum.find_or_initialize_by(name_id: name_id)

      if !museum.update(attrs)
        errors[name_id] =museum.errors
      end
    end
    errors
  end

  def sort_subway_lines
    sorted_subway_lines = []

    SUBWAY_LINES.each do |line|
      if self.subway_lines.include?(line)
        sorted_subway_lines.push(line)
        self.subway_lines = self.subway_lines - [line]
      end
    end

    sorted_subway_lines = sorted_subway_lines + self.subway_lines if !self.subway_lines.empty?

    self.subway_lines = sorted_subway_lines
  end

  SUBWAY_LINES = [
    "1", "2", "3", "4", "5", "6", "7", "A", "C", "E", "B", "D", "F", "M",
    "G", "J", "Z", "L", "S", "N", "Q", "R", "SIR"
  ]

  CATEGORIES = [
    "History", "Science", "Art", "Nature", "Other"
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
