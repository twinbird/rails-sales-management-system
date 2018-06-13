require 'test_helper'

class OrderDetailTest < ActiveSupport::TestCase

  def setup
    @buy_new_computer_line_one = order_details(:buy_new_computer_line_one)
  end

  test "should be pass" do
    assert @buy_new_computer_line_one.valid?
  end

  test "display order must be present" do
    @buy_new_computer_line_one.display_order = nil
    assert_not @buy_new_computer_line_one.valid?
  end

  test "product can be nil" do
    @buy_new_computer_line_one.product = nil
    assert @buy_new_computer_line_one.valid?
  end

  test "product name must be present" do
    @buy_new_computer_line_one.product_name = ""
    assert_not @buy_new_computer_line_one.valid?
  end

  test "product name must be less than 51" do
    @buy_new_computer_line_one.product_name = "a" * 51
    assert_not @buy_new_computer_line_one.valid?
  end

end
