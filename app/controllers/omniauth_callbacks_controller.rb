class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def google_oauth2
    oauth_sign_in
  end

  def vkontakte
    oauth_sign_in
  end

  private

  def oauth_sign_in
    data = request.env['omniauth.auth']
    user = User.from_omniauth(data, current_user)

    sign_in user unless user_signed_in?

    if current_user.daily_hours.present? && current_user.daily_hours != 0
      redirect_to root_path
    else
      redirect_to '/profile/ask'
    end
  end

end
