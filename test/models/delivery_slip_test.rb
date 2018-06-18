require 'test_helper'

class DeliverySlipTest < ActiveSupport::TestCase
  def setup
    @delivered_order = delivery_slips(:delivered_order)
  end

  test "should be pass" do
    assert @delivered_order.valid?
  end

  test "delivery date must be presence" do
    @delivered_order.delivery_date = nil
    assert_not @delivered_order.valid?
  end

  test "tax rate must be greater or equal 0 and less than 1" do
    @delivered_order.tax_rate = 0
    assert @delivered_order.valid?

    @delivered_order.tax_rate = -0.1
    assert_not @delivered_order.valid?

    @delivered_order.tax_rate = 0.9
    assert @delivered_order.valid?

    @delivered_order.tax_rate = 1.0
    assert_not @delivered_order.valid?
  end

  test "remarks must be less than 1001" do
    @delivered_order.remarks = "a" * 1000
    assert @delivered_order.valid?

    @delivered_order.remarks = "a" * 1001
    assert_not @delivered_order.valid?
  end

  test "user profile must be presence" do
    @delivered_order.user_profile = nil
    assert_not @delivered_order.valid?
  end

  test "company information must be presence" do
    @delivered_order.company_information = nil
    assert_not @delivered_order.valid?
  end

  test "submitted flag must be true or false" do
    @delivered_order.submitted_flag = nil
    assert_not @delivered_order.valid?
  end
end
