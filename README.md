Middleware in Rails -- Overriding params
----------------------------------------

This sample app shows how to use middleware to affect the params object
that is sent in the rails request.

## Creating the middleware
Middlewares in rails are classes that are loaded automatically from the
app/middleware directory. You define an initialize and call method
similar to the one below.

In this example we check if the front end send a params[:locale] and
adjust it to the first two characters. If the front end did not send it
we set it from the http header 'HTTP_ACCEPT_LANGUAGE'.

``` ruby
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
```

## Adding the middleware
In the config/application controller add the middleware.

``` ruby
  config.middleware.use 'ConvertLocale'
```

## Application Controller

In the application controller we set a before_action filter
to set the I18 locale; the middleware took care of ensuring the param
is being sent.

``` ruby
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
```

## Internationalization

To show that the environment is set when a param is not sent, you can change your browser language
setting. Then just point to the root route for this app (home controller, index action)

``` ruby
# controller code does not need to deal with parameter swapping
class HomeController < ApplicationController
  def index
  end
end
```

``` erb
index.html.erb file

<%= t('hello_the_time_is') + ' ' + Time.now.to_s %>
```

