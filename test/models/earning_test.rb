require 'test_helper'

class EarningTest < ActiveSupport::TestCase

  setup do
    @delivered_order_earning = earnings(:delivered_order_earning)
  end

  test "should be pass" do
    assert @delivered_order_earning.valid?
  end

  test "company information must be presence" do
    @delivered_order_earning.company_information = nil
    assert_not @delivered_order_earning.valid?
  end

  test "order_id must be presence" do
    @delivered_order_earning.order_id = nil
    assert_not @delivered_order_earning.valid?
  end

  test "occur date must be presence" do
    @delivered_order_earning.occur_date = nil
    assert_not @delivered_order_earning.valid?
  end

  test "amount must be presence" do
    @delivered_order_earning.amount = nil
    assert_not @delivered_order_earning.valid?
  end

  test "amount must be less than 1000000000" do
    @delivered_order_earning.amount = 1000000000
    assert_not @delivered_order_earning.valid?
  end

  test "amount must be greater than -1000000000" do
    @delivered_order_earning.amount = -1000000000
    assert_not @delivered_order_earning.valid?
  end
end
