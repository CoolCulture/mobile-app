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

  field :admin, type: Boolean, default: false
  field :family_card_id, type: Integer

  validate :needs_family_card_id

  scope :recent, ->(limit){ where(:last_sign_in_at.exists => true).limit(limit) }

  def needs_family_card_id
    if family_card_id.nil?
      errors.add(:family_card_id, "a family card id is required")
    else
      family_card = FamilyCard.where(_id: family_card_id).to_a
      errors.add(:family_card_id, "not a valid family card id") if family_card.count == 0
    end
  end

  def assign_new_password
    new_password = Devise.friendly_token.first(10)
    self.update_attributes(password: new_password, password_confirmation: new_password,
                           encrypted_password: BCrypt::Password.create(new_password))
    return new_password
  end
end
