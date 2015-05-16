require 'test_helper'
require 'rack/test'
require 'rims/controller'

class ControllerTest < MiniTest::Test

  class TestController < Rims::Controller
    description "Test Controller"

    route :post, "/test"

    action do
      "done..."
    end
  end

  def test_controller_has_description
    assert_equal "Test Controller", TestController.description
  end

  def test_route_adds_an_endpoint
    endpoint = TestController.endpoints.first
    assert_equal :post, endpoint.verb
    assert_equal "/test", endpoint.path
  end

  def test_controllers_are_registered
    assert_includes Rims::Controller.registry, TestController
  end

  def test_controller_copies_params_from_query_string
    env = Rack::MockRequest.env_for("/test/?foo=bar",
        "REQUEST_METHOD" => 'POST',
        :input => "bar=baz&qux=quux"
    )

    controller = TestController.new(env)
    assert_equal "bar", controller.params["foo"]
  end

  def test_controller_copies_params_from_post
    env = Rack::MockRequest.env_for("/test",
        "REQUEST_METHOD" => 'POST',
        :input => "foo=bar"
    )

    controller = TestController.new(env)
    assert_equal "bar", controller.params["foo"]
  end

  def test_controller_merges_params_from_post_and_query_string
    env = Rack::MockRequest.env_for("/test?foo=bar&bar=baz",
        "REQUEST_METHOD" => 'POST',
        :input => "bar=qux"
    )

    controller = TestController.new(env)
    assert_equal "bar", controller.params["foo"]
    assert_equal "qux", controller.params["bar"]
  end
end
