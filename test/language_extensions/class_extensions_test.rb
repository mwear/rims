require 'minitest_helper'

class ClassExtensionsTest < MiniTest::Test
  def test_attr_class_defaults_to_nil
    klass = Class.new do
      attr_class :meth
    end

    assert_nil klass.meth
  end

  def test_attr_class_can_set_default
    klass = Class.new do
      attr_class :meth, :default => ["monkey"]
    end

    assert_equal ["monkey"], klass.meth
  end

  def test_attr_class_assigment
    klass = Class.new do
      attr_class :meth
    end

    klass.meth = "value"

    assert_equal "value", klass.meth
  end

  def test_attr_class_inherits_superclass_value
    base = Class.new do
      attr_class :meth
    end

    klass = Class.new(base)

    base.meth = "value"

    assert_equal "value", klass.meth
  end

  def test_attr_class_does_not_mutate_superclass_value
    base = Class.new do
      attr_class :meth
    end

    klass = Class.new(base)

    base.meth = "value"
    klass.meth = "different"

    assert_equal "value", base.meth
    assert_equal "different", klass.meth
  end

  def test_attr_class_defaults_to_generating_reader_and_writer
    klass = Class.new do
      attr_class :meth
    end

    assert_respond_to klass, :meth
    assert_respond_to klass, :meth=
  end

  def test_attr_class_writer_opt_out
    klass = Class.new do
      attr_class :meth, :writer => false
    end

    assert_respond_to klass, :meth
    refute_respond_to klass, :meth=
  end

  def test_attr_class_reader_opt_out
    klass = Class.new do
      attr_class :meth, :reader => false
    end

    refute_respond_to klass, :meth
    assert_respond_to klass, :meth=
  end
end