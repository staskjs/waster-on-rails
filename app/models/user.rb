class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :registerable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable

  has_many :identities
  has_many :intervals

  before_create :generate_auth_token

  # Generate unique token
  def generate_auth_token
    self.auth_token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless self.class.exists?(auth_token: random_token)
    end
  end

  def self.from_omniauth(auth, current_user)
    identity = Identity.find_for_oauth(auth)
    if identity.user.nil?
      user = current_user || create
      identity.update_attributes(user_id: user.id) if user.persisted?
    end
    identity.user
  end

  # Disable confirmation
  # User is allowed to sign in without confirmation
  # Confirmation is only required to receive newsletter
  # and other emails
  def confirmation_required?
    false
  end

  def email_required?
    false
  end

  def password_required?
    false
  end

  def daily_hours
    super || 0
  end
end
