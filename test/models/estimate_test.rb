require 'test_helper'

class EstimateTest < ActiveSupport::TestCase

  def setup
    @buy_new_computer = estimates(:buy_new_computer)
    @misstake_estimate = estimates(:misstake_estimate)
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

  test "tax rate must be less than 100" do
    @buy_new_computer.tax_rate = 99
    assert @buy_new_computer.valid?

    @buy_new_computer.tax_rate = 100
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

  test "ordered flag must be true or false" do
    @buy_new_computer.ordered_flag = nil
    assert_not @buy_new_computer.valid?
  end

  test "search can find partial estimate title" do
    actual = Estimate.search('サーバ')
    assert_equal 1, actual.count
  end

  test "search can find partial estimate customer name" do
    actual = Estimate.search('epper')
    assert_equal 3, actual.count
  end

  test "search can find partial estimate PIC name" do
    actual = Estimate.search('田')
    assert_equal 3, actual.count
  end

  test "submitted estimate must not destroy" do
    assert @buy_new_computer.submitted_flag
    assert_no_difference('Estimate.count') do
      assert_not @buy_new_computer.destroy
    end
  end

  test "ordered estimate must not destroy" do
    @buy_new_computer.submitted_flag = false
    assert_no_difference('Estimate.count') do
      assert_not @buy_new_computer.destroy
    end
  end

  test "no submitted and ordered estimate should destroy" do
    assert_difference('Estimate.count', -1) do
      assert @misstake_estimate.destroy
    end
  end

  test "estimate no must not duplicate" do
    @misstake_estimate.estimate_no = @buy_new_computer.estimate_no
    assert_not @misstake_estimate.valid?
  end

  test "estimate no should auto allocate" do
    expect_estimate_no = @buy_new_computer.company_information.last_estimate_no + 1
    new_estimate = Estimate.new
    new_estimate.title = "new estimate"
    new_estimate.customer = @buy_new_computer.customer
    new_estimate.company_information = @buy_new_computer.company_information
    new_estimate.issue_date = @buy_new_computer.issue_date
    new_estimate.due_date = @buy_new_computer.due_date
    new_estimate.payment_term = @buy_new_computer.payment_term
    new_estimate.effective_date = @buy_new_computer.effective_date
    new_estimate.tax_rate = @buy_new_computer.tax_rate
    new_estimate.user_profile = @buy_new_computer.user_profile

    new_estimate_detail = EstimateDetail.new
    new_estimate_detail.display_order = 1
    new_estimate_detail.product_name = "test"
    new_estimate_detail.quantity = 1
    new_estimate_detail.unit_price = 1

    new_estimate.estimate_details << new_estimate_detail

    assert_difference('Estimate.count', 1) do
      assert new_estimate.save
    end
    assert_equal sprintf("%014d", expect_estimate_no), new_estimate.estimate_no
  end

  test "company informations set on created" do
    new_estimate = Estimate.new
    new_estimate.title = "new estimate"
    new_estimate.customer = @buy_new_computer.customer
    new_estimate.company_information = @buy_new_computer.company_information
    new_estimate.issue_date = @buy_new_computer.issue_date
    new_estimate.due_date = @buy_new_computer.due_date
    new_estimate.payment_term = @buy_new_computer.payment_term
    new_estimate.effective_date = @buy_new_computer.effective_date
    new_estimate.tax_rate = @buy_new_computer.tax_rate
    new_estimate.user_profile = @buy_new_computer.user_profile

    new_estimate_detail = EstimateDetail.new
    new_estimate_detail.display_order = 1
    new_estimate_detail.product_name = "test"
    new_estimate_detail.quantity = 1
    new_estimate_detail.unit_price = 1

    new_estimate.estimate_details << new_estimate_detail

    assert_difference('Estimate.count', 1) do
      assert new_estimate.save
    end

    new_estimate.reload

    assert_equal @buy_new_computer.company_information.name, new_estimate.company_name
    assert_equal @buy_new_computer.company_information.address1, new_estimate.address1
    assert_equal @buy_new_computer.company_information.address2, new_estimate.address2
    assert_equal @buy_new_computer.company_information.email, new_estimate.email
    assert_equal @buy_new_computer.company_information.tel, new_estimate.tel
    assert_equal @buy_new_computer.company_information.fax, new_estimate.fax
  end

end
