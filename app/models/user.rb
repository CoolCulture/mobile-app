class User
  include Mongoid::Document
  include Mongoid::Timestamps
  
  belongs_to :family_card

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :registerable and :omniauthable
  devise :database_authenticatable, :recoverable, 
         :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time

  ## Admin
  field :admin, type: Boolean, default: false
  
  field :family_card_id, type: Integer

  def self.import(file)
    options = { chunk_size: 5000 }

    errors = {}
    created_users = {}

    SmarterCSV.process(file, options) do |chunk|
      record = "AAAAAAAAAA"

      chunk.each do |user|
        attributes = format_attributes(user)
        user = User.new(attributes)

        family_card = FamilyCard.find(attributes[:family_card_id]) if attributes[:family_card_id]
        key = attributes[:family_card_id] || attributes[:email]

        if family_card && user.valid?
          if family_card.user.nil?
            created_users[attributes[:family_card_id]] = { 
              last_name: family_card.last_name,
              organization_name: family_card.organization_name,
              email: attributes[:email],
              password: attributes[:password],
              admin: attributes[:admin]
            }
            
            user.save
          else
            errors[key] = { user: "already exists for the family card provided" }
          end
        elsif user.valid?
          created_users[record] = { 
              email: attributes[:email],
              password: attributes[:password],
              admin: attributes[:admin]
            }
          record.succ!
          user.save
        else
          errors[key] = user.errors.messages if !user.valid?
          errors[key] = { family_card: "something went wrong with the user for this family card." }
        end
      end
    end

    { errors: errors, created_users: created_users }
  end

  private

  def self.format_attributes(user)
    password = Devise.friendly_token.first(10)

    {
      email: user[:email],
      password: password,
      password_confirmation: password,
      admin: format_admin(user[:admin]),
      family_card_id: user[:pass_id_number]
    }
  end

  def self.format_admin(admin)
    ["yes", "true", "y"].include?(admin.try(:downcase)) ? true : false
  end
end
