require 'test_helper'

class OrderTest < ActiveSupport::TestCase

  def setup
    @buy_new_computer = orders(:buy_new_computer)
  end

  test "should be pass" do
    assert @buy_new_computer.valid?
  end

  test "title must be presence" do
    @buy_new_computer.title = ""
    assert_not @buy_new_computer.valid?
  end

  test "title must be less than 70" do
    @buy_new_computer.title = "a" * 70
    assert @buy_new_computer.valid?

    @buy_new_computer.title = "a" * 71
    assert_not @buy_new_computer.valid?
  end

  test "prospect can set to nil" do
    @buy_new_computer.prospect = nil
    assert @buy_new_computer.valid?
  end

  test "estimate can set to nil" do
    @buy_new_computer.estimate = nil
    assert @buy_new_computer.valid?
  end

  test "customer must be presence" do
    @buy_new_computer.customer = nil
    assert_not @buy_new_computer.valid?
  end

  test "customer_name set from customer name" do
    @buy_new_computer.customer_name = ""
    @buy_new_computer.save
    assert_equal @buy_new_computer.customer_name, @buy_new_computer.customer.name
  end

  test "order no must be presence" do
    @buy_new_computer.order_no = ""
    assert_not @buy_new_computer.valid?
  end

  test "order no must be less than 14" do
    @buy_new_computer.order_no = "a" * 14
    assert @buy_new_computer.valid?

    @buy_new_computer.order_no = "a" * 15
    assert_not @buy_new_computer.valid?
  end

  test "issue_date must be presence" do
    @buy_new_computer.issue_date = nil
    assert_not @buy_new_computer.valid?
  end

  test "due_date must be presence" do
    @buy_new_computer.due_date = nil
    assert_not @buy_new_computer.valid?
  end

  test "payment term must be presence" do
    @buy_new_computer.payment_term = ""
    assert_not @buy_new_computer.valid?
  end

  test "payment term must be less than 50" do
    @buy_new_computer.payment_term = "a" * 50
    assert @buy_new_computer.valid?

    @buy_new_computer.payment_term = "a" * 51
    assert_not @buy_new_computer.valid?
  end

  test "tax_rate must be greater or equal 0" do
    @buy_new_computer.tax_rate = 0
    assert @buy_new_computer.valid?

    @buy_new_computer.tax_rate = -0.1
    assert_not @buy_new_computer.valid?
  end

  test "tax_rate must be less than 1" do
    @buy_new_computer.tax_rate = 1
    assert_not @buy_new_computer.valid?
  end

  test "remarks must be less than 1001" do
    @buy_new_computer.remarks = "a" * 1000
    assert @buy_new_computer.valid?

    @buy_new_computer.remarks = "a" * 1001
    assert_not @buy_new_computer.valid?
  end

  test "user profile must be presence" do
    @buy_new_computer.user_profile = nil
    assert_not @buy_new_computer.valid?
  end

  test "submitted flag must be include true or false" do
    @buy_new_computer.submitted_flag = nil
    assert_not @buy_new_computer.valid?
  end

end
