class FamilyCard
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :checkins, dependent: :delete
  has_one :user, dependent: :delete

  field :first_name, type: String
  field :last_name, type: String
  field :expiration, type: Date, default: EXPIRATION_DATE
  field :organization_name, type: String
  field :language, type: String, default: ->{ "en" }
  field :pass_id, type: Integer
  field :_id, type: Integer, default: ->{ pass_id }

  validates_presence_of :first_name, :last_name, :pass_id, :organization_name

  validates_uniqueness_of :pass_id

  def self.import(file)
    options = { chunk_size: 5000 }

    errors = {}

    SmarterCSV.process(file, options) do |chunk|
      new_chunk = []

      chunk.each do |family_card|
        attributes = format_attributes(family_card)

        if attributes.select{ |k,v| v.nil? }.empty?
          new_chunk << attributes
        else
          key = family_card[:pass_id_number] || family_card[:family_name]
          errors[key] = "Something about this isn't right: #{attributes}"
        end
      end

      FamilyCard.collection.insert(new_chunk) unless new_chunk.empty?
    end

    errors
  end

  private

  def self.format_attributes(family_card)
    pass_id = family_card[:pass_id_number]
    names = format_names(family_card[:adult_1], family_card[:adult_2], pass_id)
    organization_name = format_organization_name(family_card[:"program_name_(1st_line)"], 
                                                 family_card[:"program_name_(2nd_line)"])
    expiration = family_card[:expiration] || EXPIRATION_DATE
    language = family_card[:language] || "en"
    
    {
      _id: pass_id,
      pass_id: pass_id,
      first_name: names[:first_name],
      last_name: names[:last_name],
      expiration: expiration,
      organization_name: organization_name,
      language: language,
      created_at: DateTime.now,
      updated_at: DateTime.now
    }
  end

  def self.format_organization_name(first_line, second_line)
    if first_line && second_line
      "#{first_line} (#{second_line})"
    elsif first_line || second_line
      return first_line if first_line
      return second_line if second_line
    else
      nil
    end
  end

  def self.format_names(adult1, adult2, pass_id)
    if adult1 && adult2
      return format_last_name(adult1, adult2)
    elsif adult1 || adult2
      adult_names = adult1.split(" ") if adult1
      adult_names = adult2.split(" ") if adult2
      first_name = adult_names.first
      last_name = adult_names.last
    elsif pass_id
      first_name = last_name = "LOANER PASS"
    else
      first_name = last_name = nil
    end

    { first_name: first_name, last_name: last_name }
  end

  def self.format_last_name(adult1, adult2)  
    adult_1_names = adult1.split(" ")
    adult_2_names = adult2.split(" ")

    sorted = [adult_1_names, adult_2_names].sort_by { |names| names.last }
    
    first_name = sorted.map(&:first).join("/")
    last_name = sorted.map(&:last).join("/")
    last_name = adult_1_names.last if adult_1_names.last == adult_2_names.last

    { first_name: first_name, last_name: last_name }
  end
end
