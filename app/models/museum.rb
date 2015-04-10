class Museum
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Timestamps

  has_many :checkins, dependent: :delete
  has_many :activities, dependent: :delete

  field :name, type: String
  field :phone_number, type: String
  field :address, type: String
  field :borough, type: String
  field :site_url, type: String
  field :image_url, type: String
  field :hours, type: Array, default: []
  field :subway_lines, type: Array, default: []
  field :bus_lines, type: String
  field :additional_directional_info, type: String
  field :categories, type: Array, default: []
  field :wifi, type: Boolean
  field :handicap_accessible, type: Boolean
  field :hands_on_activity, type: Boolean
  field :description, type: String
  field :free_admission, type: Boolean
  field :suggested_donation, type: Boolean
  field :name_id, type: String, default:-> { slug }
  field :twitter, type: String
  field :facebook, type: String
  field :checkin_url, type: String

  slug do |museum|
    Museum.slug_format(museum.name)
  end

  validates_presence_of :name, :phone_number, :address, :borough,
  						          :site_url, :image_url, :hours, :categories

  validates_uniqueness_of :name

  before_save :remove_empty_hours, :sort_subway_lines
  before_update :assign_slug

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
