class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_locale

  def index
    render layout: 'application'
  end

  private

  def set_locale
    if user_signed_in?
      if current_user.locale
        I18n.locale = current_user.locale
      else
        current_user.update_attributes(locale: I18n.locale)
      end
    elsif session[:locale]
      I18n.locale = session[:locale]
    end
  end

end
