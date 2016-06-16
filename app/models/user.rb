class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :registerable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable

  has_many :identities

  def self.from_omniauth(auth)
    identity = Identity.find_for_oauth(auth)
    if identity.user.nil?
      user = self.create
      if user.persisted?
        identity.update_attributes(user_id: user.id)
      end
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
end
