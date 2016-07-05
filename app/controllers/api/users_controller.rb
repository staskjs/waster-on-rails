module Api
  class UsersController < ApplicationController

    def locale
      locale = params[:locale].to_sym
      if I18n.available_locales.exclude?(locale)
        render json: { error: 'Unsupported locale' }, status: 406
        return
      end

      current_user.update_attributes(locale: locale) if user_signed_in?
      session[:locale] = locale

      I18n.locale = locale

      render nothing: true
    end

    def profile
      current_user.update_attributes(profile_attributes)

      render current_user
    end

    def import
      call_rake('legacy:import', waster_username: params[:username], user_id: current_user.id)

      render text: 'Import started'
    end

    private

    def profile_attributes
      params.require(:user).permit(:daily_hours)
    end

  end
end
