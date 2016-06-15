class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :registerable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable

  has_many :identities

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
