require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  # this tests that the param gets set correctly if it comes from params
  # directly sent by the front end
  test 'should get param for locale' do
    get :index, {locale: 'en-US'}
    assert_equal :en, I18n.locale
  end
end
