require 'test/unit'
require 'test/unit/ui/console/testrunner'

class MyFriend < Test::Unit::TestCase
  def setup
    @friends = ['dell', 'apple', 'sony']
  end

  def teardown
  end

  def test_add
    assert_instance_of(Array, @friends, "The @friends must be Array")

    assert_equal(3, @friends.size, "The size is not 3")

    @friends << 'acer'
    assert_equal(4, @friends.size, "The size is not 4")
  end

  def test_remove
    assert_equal(3, @friends.size, "The size is not 3")

    @friends.delete_if {|n| n == 'apple'}
    assert_equal(2, @friends.size, "The size is not 2")
  end

  def login

  end
end



Test::Unit::UI::Console::TestRunner.run(MyFriend)
