class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_locale

  before_action :check_auth_token, if: ->{ params[:auth_token].present? }

  def index
    render layout: 'application'
  end

  protected

  def call_rake(task, options = {})
    options[:rails_env] ||= Rails.env
    args = options.map { |name, value| "#{name.to_s.upcase}='#{value}'" }
    system "cd #{Rails.root}; bundle exec rake #{task} #{args.join(' ')} --trace 2>&1 >> #{Rails.root}/log/rake.log &"
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

  # Find user by auth token and authenticate if found
  def check_auth_token
    unless user_signed_in?
      user = User.find_by_auth_token(params[:auth_token])
      if user
        sign_in user
      end
    end
  end

end
