class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def twitter

  end

  def vkontakte
    ap request.env['omniauth.auth']
    redirect_to root_path
  end

end
