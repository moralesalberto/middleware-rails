class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # apply this filter to all requests
  before_action :set_locale

  # set the locale
  def set_locale
    # still double check if params is blank then apply the default locale
    # otherwise grab the first two characters from the params[:locale]
    # which the middleware set for us
    I18n.locale = params[:locale].blank? ? I18n.default_locale : params[:locale][0,2]
  rescue I18n::InvalidLocale => e
    Rails.logger.error(e.message)
    I18n.default_locale
  end
end
