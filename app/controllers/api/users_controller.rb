module Api
  class UsersController < ApplicationController

    def locale
      locale = params[:locale].to_sym
      if I18n.available_locales.exclude?(locale)
        render json: {error: 'Unsupported locale'}, status: 406
        return
      end

      if user_signed_in?
        current_user.update_attributes(locale: locale)
      end
      session[:locale] = locale

      I18n.locale = locale

      render nothing: true
    end

    def import
      call_rake('legacy:import', {waster_username: params[:username]})

      render text: 'Import started'
    end

  end
end
