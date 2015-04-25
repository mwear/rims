require 'minitest_helper'

class ControllerTest < MiniTest::Test

  class FakeController < Rims::Controller
    description "Fake Controller"

    route :post, "/fake"

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
    assert_equal "Fake Controller", FakeController.description
  end

  def test_route_adds_an_endpoint
    endpoint = FakeController.endpoints.first
    assert_equal "POST", endpoint.verb
    assert_equal "/fake", endpoint.path
  end

  def test_controllers_are_registered
    assert_includes Rims::Controller.registry, FakeController
  end

  def test_controllers_can_render_statuses
    f = FourOhFourController.new(MiniTest::Mock.new)
    result = f.call
    assert_equal 404, result[0]
    assert_equal ["Oh no!"], result[2]
  end
end
