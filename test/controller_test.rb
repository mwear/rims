require 'minitest_helper'
require 'rack/test'

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
    assert_equal "POST", endpoint.verb
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

  class FourOhFourController < Rims::Controller
    description "404s"
    route :get, "/nonexistent"
    action do
      render "Oh no!", status: 404
    end
  end

  def test_controllers_can_render_statuses
    f = FourOhFourController.new(MiniTest::Mock.new)
    result = f.call
    assert_equal 404, result[0]
    assert_equal ["Oh no!"], result[2]
  end

  class ControllerWithHeaders < Rims::Controller
    description "Test controller with headers"
    route :get, "/widgets"
    action do
      status 201
      headers location: "/widgets/10"
    end
  end

  def test_controllers_can_return_headers
    controller = ControllerWithHeaders.new({})
    _, headers, body = controller.call
    assert_equal({location: "/widgets/10"}, headers)
    assert_kind_of(String, body[0])
  end
end
