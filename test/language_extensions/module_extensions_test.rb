require 'minitest_helper'

class ModuleExtensionsTest < MiniTest::Test
  def test_attr_func_defaults_to_nil
    klass = Class.new do
      attr_func :meth
    end
    instance = klass.new
    assert_nil instance.meth
  end

  def test_attr_func_sets_and_returns_value
    klass = Class.new do
      attr_func :meth
    end

    instance = klass.new

    instance.meth "value"
    assert_equal "value", instance.meth
  end
end