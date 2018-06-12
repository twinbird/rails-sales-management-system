require 'test_helper'

class EstimateDetailTest < ActiveSupport::TestCase

  def setup
    @buy_new_computer_line_one = estimate_details(:buy_new_computer_line_one)
  end

  test "should be pass" do
    assert @buy_new_computer_line_one.valid?
  end

  test "display order must be present" do
    @buy_new_computer_line_one.display_order = nil
    assert_not @buy_new_computer_line_one.valid?
  end

  test "product name must be present" do
    @buy_new_computer_line_one.product_name = ""
    assert_not @buy_new_computer_line_one.valid?
  end

  test "product name must be less than 50" do
    @buy_new_computer_line_one.product_name = "a" * 51
    assert_not @buy_new_computer_line_one.valid?
  end

  test "quantity must be present" do
    @buy_new_computer_line_one.quantity = nil
    assert_not @buy_new_computer_line_one.valid?
  end

  test "quantity must be greater than 0" do
    @buy_new_computer_line_one.quantity = 0
    assert_not @buy_new_computer_line_one.valid?

    @buy_new_computer_line_one.quantity = 1
    assert @buy_new_computer_line_one.valid?
  end

  test "quantity must be less than 1000" do
    @buy_new_computer_line_one.quantity = 1000
    assert_not @buy_new_computer_line_one.valid?

    @buy_new_computer_line_one.quantity = 999
    assert @buy_new_computer_line_one.valid?
  end

  test "unit price must be presence" do
    @buy_new_computer_line_one.unit_price = nil
    assert_not @buy_new_computer_line_one.valid?
  end

  test "unit price must be greater than -1000000000" do
    @buy_new_computer_line_one.unit_price = -1000000000
    assert_not @buy_new_computer_line_one.valid?

    @buy_new_computer_line_one.unit_price = -999999999
    assert @buy_new_computer_line_one.valid?
  end

  test "unit price must be less than 1000000000" do
    @buy_new_computer_line_one.unit_price = 1000000000
    assert_not @buy_new_computer_line_one.valid?

    @buy_new_computer_line_one.unit_price = 999999999
    assert @buy_new_computer_line_one.valid?
  end

  test "price must be 0 if unit price is nil" do
    @buy_new_computer_line_one.unit_price = nil
    assert_equal @buy_new_computer_line_one.price, 0
  end

  test "price must be 0 if quantity is nil" do
    @buy_new_computer_line_one.quantity = nil
    assert_equal @buy_new_computer_line_one.price, 0
  end

  test "price is multiple quantity and unit price" do
    assert_equal @buy_new_computer_line_one.price, @buy_new_computer_line_one.quantity * @buy_new_computer_line_one.unit_price
  end

end
