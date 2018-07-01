require 'test_helper'

class CustomerTest < ActiveSupport::TestCase

  def setup
    @customer = customers(:mint)
    @pepper = customers(:pepper)
    @no_use_customer = customers(:no_use_customer)
  end

  test "should be pass" do
    assert @customer.valid?
  end

  test "name must be present" do
    @customer.name = ""
    assert_not @customer.valid?
  end

  test "name must be less than 50" do
    @customer.name = "a" * 51
    assert_not @customer.valid?

    @customer.name = "a" * 50
    assert @customer.valid?
  end

  test "payment_term accept empty" do
    @customer.payment_term = ""
    assert @customer.valid?
  end

  test "payment_term must be less than 50" do
    @customer.payment_term = "a" * 51
    assert_not @customer.valid?

    @customer.payment_term = "a" * 50
    assert @customer.valid?
  end

  test "search should return only partial match 'name' customers" do
    customers = Customer.search('顧客')
    assert_equal customers.count, 90

    customers = Customer.search('ント')
    assert_equal customers.count, 1

    customers = Customer.search('not found')
    assert_equal customers.count, 0
  end

  test "latest_sales_reports return descending by occur_date" do
    sales_reports = @pepper.latest_sales_reports(5)
    expect = SalesReport.where(customer_id: @pepper.id).order(occur_date: :desc).limit(5)

    assert_equal sales_reports, expect
  end

  test "latest_sales_reports return less than or equal spec limit size reports" do
    size = 4
    sales_reports = @pepper.latest_sales_reports(size)
    assert_equal size, sales_reports.count

    empty_reports = @no_use_customer.latest_sales_reports(size)
    assert_equal 0, empty_reports.count
  end

  test "latest_prospects return descending by created_at" do
    prospects = @customer.latest_prospects(5)
    expect = Prospect.where(customer_id: @customer).order(created_at: :desc).limit(5)

    assert_equal expect, prospects
  end

  test "latest_prospects return less than or equal spec limit size prospects" do
    size = 4
    prospects = @customer.latest_prospects(size)
    assert_equal size, prospects.count

    empty_prospects = @no_use_customer.latest_prospects(size)
    assert_equal 0, empty_prospects.count
  end

  test "latest_estimates return less than or equal spec limit size estimates" do
    size = 4
    estimates = @customer.latest_estimates(size)
    assert_equal size, estimates.count

    empty_estimates = @no_use_customer.latest_estimates(size)
    assert_equal 0, empty_estimates.count
  end

end
