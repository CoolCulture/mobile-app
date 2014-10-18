class FamilyCard
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :checkins, dependent: :delete
  belongs_to :user

  field :first_name, type: String
  field :last_name, type: String
  field :expiration, type: Date, default: ->{ Date.new(2014, 10, 31) }
  field :organization_name, type: String
  field :language, type: String, default: ->{ "en" }
  field :pass_id, type: Integer
  field :user_id, type: String
  field :_id, type: Integer, default: ->{ pass_id }

  validates_presence_of :first_name, :last_name, :pass_id, :organization_name

  validates_uniqueness_of :pass_id

  def valid_last_name(name)
    valid = false
    if last_name
      last_names = last_name.downcase.sub(' ','').split('/')
      if last_names.include? name.downcase
        valid = true
      end
    end
    valid
  end

  def self.import(file)
    options = { chunk_size: 5000 }

    errors = {}

    SmarterCSV.process(file, options) do |chunk|
      chunk.each do |family_card|        
        attributes = {
          pass_id: family_card[:pass_id],
          first_name: family_card[:first_name],
          last_name: family_card[:last_name],
          expiration: family_card[:expiration],
          organization_name: family_card[:organization_name],
          language: family_card[:language]  
        }

        card = FamilyCard.new(attributes)
        user = User.new(email: family_card[:email], 
                        password: Devise.friendly_token.first(10))

        if card.valid? && user.valid?
          user.save
          card.user = user
          card.save
        else
          pass = family_card[:pass_id]
          errors[pass] = {}
          errors[pass][:user] = user.errors.messages if !user.valid?
          errors[pass][:family_card] = card.errors.messages if !card.valid?
        end
      end
    end
    errors
  end
end
