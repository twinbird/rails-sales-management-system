require 'test_helper'

class ProspectTest < ActiveSupport::TestCase

  def setup
    @buy_new_computer = prospects(:buy_new_computer)
  end

  test "should be pass" do
    assert @buy_new_computer.valid?
  end

  test "title must be present" do
    @buy_new_computer.title = ""
    assert_not @buy_new_computer.valid?
  end

  test "title must be less than 50" do
    @buy_new_computer.title = "a" * 51
    assert_not @buy_new_computer.valid?
  end

  test "rank must be present" do
    @buy_new_computer.rank = nil
    assert_not @buy_new_computer.valid?
  end

  test "distribute must be less than 100" do
    @buy_new_computer.distribute = "a" * 101
    assert_not @buy_new_computer.valid?
  end

end
