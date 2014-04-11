class FamilyCard
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :checkins, dependent: :delete

  field :last_name, type: String
  field :pass_id, type: Integer
  field :expiration, type: Date, default: ->{ Date.new(2014, 10, 31) }
  field :_id, type: Integer, default: ->{ pass_id }
  field :center_name, type: String
  field :school_type, type: String
  field :adult1_first, type: String
  field :adult1_last, type: String
  field :adult2_first, type: String
  field :adult2_last, type: String
  field :family_or_staff, type: String
  field :spanish_form, type: String
  field :chinese_form, type: String
  field :city, type: String
  field :state, type: String
  field :child_1_first_name, type: String
  field :child_1_last_name, type: String
  field :child_2_first_name, type: String
  field :child_2_last_name, type: String
  field :notes, type: String


  validates_presence_of :last_name, :pass_id, :expiration, :center_name, :school_type

  validates_uniqueness_of :pass_id

  def valid_last_name(name)
    if last_name
      last_name.downcase == name.downcase ? true : false
    else
      false
    end
  end

  def self.import(file)
    options = {
      chunk_size: 500,
      key_mapping: {
        adult_last: :last_name,
        :"pass_id_no." => :pass_id,
        :"dob1__mm-dd-yy" => nil
      }
    }

    errors = {}

    SmarterCSV.process(file, options) do |chunk|
      # attrs = row.first

      # family_card = FamilyCard.find_or_initialize_by(pass_id: attrs[:pass_id])

      # if !family_card.update(attrs)
      #   errors[attrs[:pass_id]] =family_card.errors
      # end

      FamilyCard.collection.insert(chunk)

    end
    errors
  end

end
