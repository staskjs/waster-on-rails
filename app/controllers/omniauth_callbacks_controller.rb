class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def google_oauth2
    data = request.env['omniauth.auth']
    user = User.from_omniauth(data)
    sign_in user

    redirect_to root_path
  end

  def vkontakte
    data = request.env['omniauth.auth']
    user = User.from_omniauth(data)
    sign_in user

    redirect_to root_path
  end

end
