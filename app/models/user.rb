class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable

  # Disable confirmation
  # User is allowed to sign in without confirmation
  # Confirmation is only required to receive newsletter
  # and other emails
  def confirmation_required?
    false
  end
end
