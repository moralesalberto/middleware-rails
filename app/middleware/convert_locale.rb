# middleware class to set a param before
# rails request object is built
#
# setting the params[:locale] if not sent
class ConvertLocale
  def initialize(app)
    @app = app
  end

  def call(env)
    # create a request object
    request = Rack::Request.new(env)

    # check to make sure the locale param is sent, if not then use the HTTP_ACCEPT_LANGUAGE header
    locale_param = env['locale'].blank? ? env['HTTP_ACCEPT_LANGUAGE'] : env['locale']

    # make sure we only take the first two characters from the param
    request.update_param('locale', locale_param.to_s[0,2])

    # quick way to test this works
    # request.update_param('locale', 'es')

    # now back to rails
    @status, @headers, @response = @app.call(env)
  end
end
