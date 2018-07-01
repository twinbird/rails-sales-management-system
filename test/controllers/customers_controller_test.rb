require 'test_helper'

class CustomersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @sato = users(:sato)
    @new_user = users(:new_user)
    @pepper = customers(:pepper)
    @mint = customers(:mint)
  end

  test "can't access not setup user" do
    sign_in(@new_user)

    get customers_path
    assert_redirected_to mysetting_path
    follow_redirect!
    assert_not flash[:notice].empty?
  end

  test "can't access not signin user" do
    get customers_path
    assert_redirected_to new_user_session_path
  end

  test "add new customer" do
    sign_in(@sato)

    get customers_path
    assert_response :success
    assert_select 'a[href=?]', new_customer_path, count: 1

    get new_customer_path
    assert_response :success

    # miss post(name is empty)
    assert_no_difference('Customer.count') do
      post customers_path, params: { customer: { name: '',
                                                 payment_term: '月末締め翌々月末現金支払い' } }
    end
    assert_response :success
    assert_select '#error_explanation'

    # correct post
    assert_difference('Customer.count', 1) do
      post customers_path, params: { customer: { name: '顧客1',
                                                 payment_term: '月末締め翌々月末現金支払い' } }
    end
    assert_redirected_to Customer.last
    follow_redirect!
    assert_not flash.empty?
  end

  test "edit customer" do
    sign_in(@sato)

    get customers_path
    assert_response :success
    assert_select 'a[href=?]', customer_path(@pepper)

    get customer_path(@pepper)
    assert_response :success
    assert_select 'a[href=?]', edit_customer_path(@pepper)

    get edit_customer_path(@pepper)
    assert_response :success

    # input miss
    patch customer_path(@pepper), params: { customer: { name: '',
                                                        payment_term: '月末締め翌月末現金払い' } }
    assert_response :success
    assert_select '#error_explanation', count: 1
    assert_not_equal @pepper.reload.name, ''

    # valid input
    patch customer_path(@pepper), params: { customer: { name: '顧客1',
                                                        payment_term: '月末締め翌月末現金払い' } }
    assert_redirected_to @pepper
    follow_redirect!
    assert_not flash.empty?

    assert_equal @pepper.reload.name, '顧客1'
  end

  test "delete customer" do
    sign_in(@sato)

    get customers_path
    assert_response :success
    assert_select 'a[href=?]', customer_path(@pepper)

    # pepper should not delete with restrict_with_error
    assert_no_difference('Customer.count') do
      delete customer_path(@pepper)
    end
    assert_redirected_to customers_path
    assert_not flash.empty?

    # no use customer can be destroy
    assert_difference('Customer.count', -1) do
      delete customer_path(customers(:no_use_customer))
    end
    assert_redirected_to customers_path
    assert_not flash.empty?
  end

  test "listing customer" do
    sign_in(@sato)

    get customers_path
    assert_response :success
    assert_select 'a[href=?]', customer_path(@pepper)

    # other user company customer must not found
    assert_select 'a[href=?]', customer_path(@mint), count: 0

    assert_select 'nav.pagination'
  end

  test "search listing customer" do
    sign_in(@sato)

    get customers_path
    assert_response :success
    assert_select 'a[href=?]', customer_path(@pepper)

    # should found search
    get customers_path, params: { query: 'pepper' }
    assert_response :success
    assert_select 'a[href=?]', customer_path(@pepper)
    assert_select 'input[value=?]', 'pepper'

    # shouldn't found search
    get customers_path, params: { query: 'hoge' }
    assert_select 'a[href=?]', customer_path(@pepper), count: 0
    assert_select 'input[value=?]', 'hoge'
  end

  test "listing latest prospects" do
    sign_in(@sato)

    expect_prospects = @pepper.latest_prospects(5)

    get customer_path(@pepper)
    assert_response :success

    expect_prospects.each do |prospect|
      assert_select 'a[href=?]', prospect_path(prospect)
    end
  end

  test "listing latest sales reports" do
    sign_in(@sato)

    expect_sales_reports = @pepper.latest_sales_reports(5)

    get customer_path(@pepper)
    assert_response :success

    expect_sales_reports.each do |sales_report|
      assert_select 'a[href=?]', sales_report_path(sales_report)
    end
  end

end
