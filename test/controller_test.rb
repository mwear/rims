require 'minitest_helper'

class ControllerTest < MiniTest::Test

  class FakeController < Rims::Controller
    description "Fake Controller"

    route :post, "/fake"

    action do
      "done..."
    end
  end

  def test_controller_has_description
    assert_equal "Fake Controller", FakeController.description
  end

  def test_route_adds_an_endpoint
    endpoint = FakeController.endpoints.first
    assert_equal :post, endpoint.verb
    assert_equal "/fake", endpoint.path
  end

  def test_controllers_are_registered
    assert_includes Rims::Controller.registry, FakeController
  end
end