class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def twitter

  end

  def vkontakte
    data = request.env['omniauth.auth']
    identity = Identity.find_for_oauth(data)
    if identity.user.nil?
      user = User.create
      if user.persisted?
        identity.update_attributes(user_id: user.id)
      end
    end
    sign_in identity.user

    redirect_to root_path
  end

end
