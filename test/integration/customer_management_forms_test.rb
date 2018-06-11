require 'test_helper'

class CustomerManagementFormsTest < ActionDispatch::IntegrationTest
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

    post customers_path, params: { customer: { name: '顧客1',
                                               payment_term: '月末締め翌々月末現金支払い' } }
    follow_redirect!
    assert_not flash.empty?
  end

  test "edit customer" do
    sign_in(@sato)

    get customers_path
    assert_response :success
    assert_select 'a[href=?]', edit_customer_path(@pepper)

    get edit_customer_path(@pepper)
    assert_response :success

    # input miss
    patch customer_path(@pepper), params: { customer: { name: '',
                                                        payment_term: '月末締め翌月末現金払い' } }
    assert_response :success
    assert_select '#error_explanation', count: 1

    # valid input
    patch customer_path(@pepper), params: { customer: { name: '顧客1',
                                                        payment_term: '月末締め翌月末現金払い' } }
    assert_redirected_to @pepper
    follow_redirect!
    assert_not flash.empty?
  end

  test "delete customer" do
    sign_in(@sato)

    get customers_path
    assert_response :success
    assert_select 'a[href=?]', customer_path(@pepper)

    delete customer_path(@pepper)
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

    assert_select 'div.pagination'
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

end
