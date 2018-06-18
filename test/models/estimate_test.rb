require 'test_helper'

class EstimateTest < ActiveSupport::TestCase

  def setup
    @buy_new_computer = estimates(:buy_new_computer)
  end

  test "should be pass" do
    assert @buy_new_computer.valid?
  end

  test "title must be present" do
    @buy_new_computer.title = ""
    assert_not @buy_new_computer.valid?
  end

  test "title must be less than 70" do
    @buy_new_computer.title = "a" * 70
    assert @buy_new_computer.valid?

    @buy_new_computer.title = "a" * 71
    assert_not @buy_new_computer.valid?
  end

  test "customer name must be setting from customer name" do
    @buy_new_computer.customer_name = ""
    assert @buy_new_computer.valid?

    @buy_new_computer.save
    assert_equal @buy_new_computer.customer_name, @buy_new_computer.customer.name
  end

  test "estimate no must be present" do
    @buy_new_computer.estimate_no = ""
    assert_not @buy_new_computer.valid?
  end

  test "estimate no must be less than 14" do
    @buy_new_computer.estimate_no = "yyyymmddHHMMSS"
    assert @buy_new_computer.valid?

    @buy_new_computer.estimate_no = "yyyymmddHHMMSS1"
    assert_not @buy_new_computer.valid?
  end

  test "issue date must be present" do
    @buy_new_computer.issue_date = nil
    assert_not @buy_new_computer.valid?
  end

  test "due date must be present unless due date set pending" do
    @buy_new_computer.due_date_pending_flag = false
    @buy_new_computer.due_date = nil
    assert_not @buy_new_computer.valid?

    @buy_new_computer.due_date_pending_flag = true
    @buy_new_computer.due_date = nil
    assert @buy_new_computer.valid?
  end

  test "due_date_pending_flag must be true or false" do
    @buy_new_computer.due_date_pending_flag = nil
    assert_not @buy_new_computer.valid?
  end

  test "payment_term must be present" do
    @buy_new_computer.payment_term = ""
    assert_not @buy_new_computer.valid?
  end

  test "payment_term must be less than 50" do
    @buy_new_computer.payment_term = "a" * 50
    assert @buy_new_computer.valid?

    @buy_new_computer.payment_term = "a" * 51
    assert_not @buy_new_computer.valid?
  end

  test "effective date must be present" do
    @buy_new_computer.effective_date = nil
    assert_not @buy_new_computer.valid?
  end

  test "tax rate must be greater than or equal 0" do
    @buy_new_computer.tax_rate = 0
    assert @buy_new_computer.valid?

    @buy_new_computer.tax_rate = -1
    assert_not @buy_new_computer.valid?
  end

  test "tax rate must be less than 1" do
    @buy_new_computer.tax_rate = 0.9
    assert @buy_new_computer.valid?

    @buy_new_computer.tax_rate = 1
    assert_not @buy_new_computer.valid?
  end

  test "remarks must be less than 1000" do
    @buy_new_computer.remarks = "a" * 1000
    assert @buy_new_computer.valid?

    @buy_new_computer.remarks = "a" * 1001
    assert_not @buy_new_computer.valid?
  end

  test "estimate must has detail" do
    @buy_new_computer.estimate_details = []
    assert_not @buy_new_computer.valid?
  end

  test "submitted flag must be true or false" do
    @buy_new_computer.submitted_flag = nil
    assert_not @buy_new_computer.valid?
  end

end
