require 'abstract_unit'
require 'active_support/core_ext/class/attribute'

class ClassAttributeTest < ActiveSupport::TestCase
  def setup
    @klass = Class.new { class_attribute :setting }
    @sub = Class.new(@klass)

    @proc_klass = Class.new { class_attribute :setting, proc: true }
    @proc_sub = Class.new(@proc_klass)
  end

  test 'defaults to nil' do
    assert_nil @klass.setting
    assert_nil @sub.setting
  end

  test 'inheritable' do
    @klass.setting = 1
    assert_equal 1, @sub.setting
  end

  test 'overridable' do
    @sub.setting = 1
    assert_nil @klass.setting

    @klass.setting = 2
    assert_equal 1, @sub.setting

    assert_equal 1, Class.new(@sub).setting
  end

  test 'overridable with procs' do
    sub_setting = 1
    @proc_sub.setting = lambda { sub_setting }
    assert_nil @proc_klass.setting

    klass_setting = 2
    @proc_klass.setting = lambda { klass_setting }
    assert_equal 1, @proc_sub.setting

    assert_equal 1, Class.new(@proc_sub).setting
  end

  test 'predicate method' do
    assert_equal false, @klass.setting?
    @klass.setting = 1
    assert_equal true, @klass.setting?
  end

  test 'instance reader delegates to class' do
    assert_nil @klass.new.setting

    @klass.setting = 1
    assert_equal 1, @klass.new.setting
  end

  test 'instance override' do
    object = @klass.new
    object.setting = 1
    assert_nil @klass.setting
    @klass.setting = 2
    assert_equal 1, object.setting
  end

  test 'instance predicate' do
    object = @klass.new
    assert_equal false, object.setting?
    object.setting = 1
    assert_equal true, object.setting?
  end

  test 'disabling instance writer' do
    object = Class.new { class_attribute :setting, :instance_writer => false }.new
    assert_raise(NoMethodError) { object.setting = 'boom' }
  end

  test 'disabling instance reader' do
    object = Class.new { class_attribute :setting, :instance_reader => false }.new
    assert_raise(NoMethodError) { object.setting }
    assert_raise(NoMethodError) { object.setting? }
  end

  test 'disabling both instance writer and reader' do
    object = Class.new { class_attribute :setting, :instance_accessor => false }.new
    assert_raise(NoMethodError) { object.setting }
    assert_raise(NoMethodError) { object.setting? }
    assert_raise(NoMethodError) { object.setting = 'boom' }
  end

  test 'disabling instance predicate' do
    object = Class.new { class_attribute :setting, instance_predicate: false }.new
    assert_raise(NoMethodError) { object.setting? }
  end

  test 'delegating class attribute with lambda on instance' do
    object = Class.new { class_attribute :setting, proc: true }.new
    real_setting = "5"
    object.setting = lambda { real_setting }
    assert_equal "5", object.setting

    real_setting = "10"
    assert_equal "10", object.setting
  end

  test 'delegating class attribute with lambda on singleton class' do
    object = @proc_klass.new
    setting = "5"
    object.singleton_class.setting = lambda { setting }
    assert_equal "5", object.setting

    setting = "10"
    assert_equal "10", object.setting
  end

  test 'works well with singleton classes' do
    object = @klass.new
    object.singleton_class.setting = 'foo'
    assert_equal 'foo', object.setting
  end

  test 'setter returns set value' do
    val = @klass.send(:setting=, 1)
    assert_equal 1, val
  end
end
