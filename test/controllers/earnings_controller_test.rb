require 'test_helper'

class EarningsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @sato = users(:sato)
    @new_user = users(:new_user)
    @earning = earnings(:delivered_order_earning)
    @pending_delivery_order = orders(:pending_delivery_order)
  end

  test "can't access not setup user" do
    sign_in(@new_user)

    get earnings_path
    assert_redirected_to mysetting_path
    follow_redirect!
    assert_not flash[:notice].empty?
  end

  test "can't access not signin user" do
    get earnings_path
    assert_redirected_to new_user_session_path
  end

  test "listing earnings" do
    sign_in(@sato)

    get earnings_path
    assert_response :success
    assert_select 'tbody>tr', count: 20
    assert_select 'div.pagination'
  end

  test "search earnings" do
    sign_in(@sato)

    get earnings_path, params: { query: @earning.order.title }
    assert_response :success
    assert_select 'tbody>tr', count: 1
    assert_select 'div.pagination', count: 0
  end

  test "add new earning" do
    sign_in(@sato)

    get earnings_path
    assert_response :success
    assert_select 'a[href=?]', new_earning_path

    assert_difference('Earning.count', 1) do
      post earnings_path, params: { earning: { order_id: @pending_delivery_order.id,
                                               occur_date: '2017-12-20',
                                               amount: 11000000 } } 
    end
    assert_redirected_to Earning.last
  end

  test "editing earning" do
    sign_in(@sato)

    get earnings_path, params: { query: @earning.order.title }
    assert_response :success
    assert_select 'tbody>tr', count: 1
    assert_select 'a[href=?]', edit_earning_path(@earning)

    get edit_earning_path(@earning)
    assert_response :success

    expect_date = @earning.occur_date.tomorrow
    patch earning_path(@earning), params: { earning: { occur_date: expect_date } }
    assert_redirected_to @earning
    assert_equal @earning.reload.occur_date, expect_date
  end

  test "destroy earning" do
    sign_in(@sato)

    get earnings_path, params: { query: @earning.order.title }
    assert_response :success
    assert_select 'tbody>tr', count: 1
    assert_select 'a[href=?]', edit_earning_path(@earning)

    assert_difference('Earning.count', -1) do
      delete earning_path(@earning)
    end
    assert_redirected_to earnings_path

  end

end
