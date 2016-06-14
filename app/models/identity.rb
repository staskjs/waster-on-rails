class Identity < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :uid, :provider
  validates_presence_of :uid, scope: :provider

  # Find or create a record for passed auth parameters
  #
  def self.find_for_oauth(auth)
    find_or_create_by(uid: auth.uid, provider: auth.provider)
  end
end
