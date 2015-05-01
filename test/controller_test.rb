require 'minitest_helper'

class ControllerTest < MiniTest::Test

  class TestController < Rims::Controller
    description "Test Controller"

    route :post, "/test"

    action do
      "done..."
    end
  end

  class FourOhFourController < Rims::Controller
    description "404s"
    route :get, "/nonexistent"
    action do
      render "Oh no!", status: 404
    end
  end

  def test_controller_has_description
    assert_equal "Test Controller", TestController.description
  end

  def test_route_adds_an_endpoint
    endpoint = TestController.endpoints.first
    assert_equal "POST", endpoint.verb
    assert_equal "/test", endpoint.path
  end

  def test_controllers_are_registered
    assert_includes Rims::Controller.registry, TestController
  end

  def test_controllers_can_render_statuses
    f = FourOhFourController.new(MiniTest::Mock.new)
    result = f.call
    assert_equal 404, result[0]
    assert_equal ["Oh no!"], result[2]
  end
end
