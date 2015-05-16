require 'test_helper'
require 'rims/controller'
require 'rims/test_case'

class FourOhFourController < Rims::Controller
  description "404s"
  route :get, "/nonexistent"
  action do
    render "Oh no!", status: 404
  end
end

class StatusTest < Rims::TestCase
  tests FourOhFourController

  def test_controllers_can_render_statuses
    get "/nonexistent"

    assert_equal 404, last_response.status
    assert_equal "Oh no!", last_response.body
  end
end