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

  def self.import(file)
    options = { chunk_size: 5000 }

    errors = {}
    created_users = {}

    SmarterCSV.process(file, options) do |chunk|
      chunk.each do |family_card|
        attributes = format_attributes(family_card)
        admin = format_admin(family_card[:admin])
        password = Devise.friendly_token.first(10)

        card = FamilyCard.new(attributes)
        user = User.new(email: family_card[:email], admin: admin,
                        password: password, password_confirmation: password)

        if user.valid? && card.valid?
          user.save
          card.user = user
          card.save
          created_users[card.pass_id] = { first_name: card.first_name, last_name: card.last_name,
                                          email: user.email, password: password }
        elsif card.valid? && !family_card[:email]
          card.save
          created_users[card.pass_id] = { first_name: card.first_name, last_name: card.last_name,
                                          email: "NO EMAIL PROVIDED", password: "NO EMAIL PROVIDED" }
        else
          key = family_card[:pass_id_number] || family_card[:email] || password
          errors[key] = {}
          errors[key][:user] = user.errors.messages if !user.valid?
          errors[key][:family_card] = card.errors.messages if !card.valid?
        end
      end
    end
    
    format_response(errors, created_users)
  end

  private

  def self.format_response(errors, created_users)
    response = {}
    response[:errors] = errors if errors.present?
    response[:created_users] = created_users if created_users.present?

    response
  end

  def self.format_attributes(family_card)
    pass_id = family_card[:pass_id_number]
    names = format_names(family_card[:adult_1], family_card[:adult_2], pass_id)
    organization_name = format_organization_name(family_card[:"program_name_(1st_line)"], 
                                                 family_card[:"program_name_(2nd_line)"])
    expiration = family_card[:expiration] || Date.new(2015,10,31)
    language = family_card[:language] || "en"
    
    {
      pass_id: pass_id,
      first_name: names[:first_name],
      last_name: names[:last_name],
      expiration: expiration,
      organization_name: organization_name,
      language: language
    }
  end

  def self.format_admin(admin)
    true if ["yes", "true", "y"].include?(admin.try(:downcase))
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
      adult_1_names = adult1.split(" ")
      adult_2_names = adult2.split(" ")
      return format_last_name(adult_1_names, adult_2_names)
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

  def self.format_last_name(adult_1_names, adult_2_names)  
    sorted = [adult_1_names, adult_2_names].sort_by { |names| names.last }
    
    first_name = sorted.map(&:first).join("/")
    last_name = sorted.map(&:last).join("/")
    last_name = adult_1_names.last if adult_1_names.last == adult_2_names.last

    { first_name: first_name, last_name: last_name }
  end
end
