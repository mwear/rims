require 'minitest_helper'
require 'rims/test_case'
require 'rims/controller'

class TestCaseTest < Minitest::Test
  class BasicController < Rims::Controller
    route :post, "/endpoint"
    action do
      "basic_controller"
    end
  end

  class TestTestCase < Rims::TestCase
    tests BasicController
  end

  def setup
    @test_case = TestTestCase.new("Test Test Case")
  end

  def test_test_case_sets_app
    assert_equal BasicController, @test_case.app
  end

  def test_test_case_collects_allowed_http_verbs
    assert_equal [:post], @test_case.allowed_http_verbs
  end

  def test_test_case_raises_exception_when_using_invalid_http_verb
    assert_raises(Rims::TestCase::RoutingError) do
      @test_case.get("whatever")
    end
  end
end