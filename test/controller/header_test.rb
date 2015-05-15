require 'minitest_helper'
require 'rims/test_case'
require 'rims/controller'

class ControllerWithHeaders < Rims::Controller
  description "Test controller with headers"
  route :get, "/widgets"
  action do
    status 201
    headers location: "/widgets/10"
  end
end

class HeaderTest < Rims::TestCase
  tests ControllerWithHeaders

  def test_controllers_return_headers
    get "/widgets"
    assert_equal "/widgets/10", last_response.headers[:location]
  end
end