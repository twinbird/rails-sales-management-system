require 'test_helper'

class DeliverySlipDetailTest < ActiveSupport::TestCase
  def setup
    @delivered_order_one = delivery_slip_details(:delivered_order_one)
  end

  test "should be pass" do
    assert @delivered_order_one.valid?
  end

  test "delivery_slip must be presence" do
    @delivered_order_one.delivery_slip = nil
    assert_not @delivered_order_one.valid?
  end

  test "order_detail must be presence" do
    @delivered_order_one.order_detail = nil
    assert_not @delivered_order_one.valid?
  end

  test "display_order must be presence" do
    @delivered_order_one.display_order = nil
    assert_not @delivered_order_one.valid?
  end

  test "display_order greater than 1" do
    @delivered_order_one.display_order = 0
    assert_not @delivered_order_one.valid?

    @delivered_order_one.display_order = 1
    assert @delivered_order_one.valid?
  end

  test "display_order less than 11" do
    @delivered_order_one.display_order = 11
    assert_not @delivered_order_one.valid?

    @delivered_order_one.display_order = 10
    assert @delivered_order_one.valid?
  end
end
