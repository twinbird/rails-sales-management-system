require 'test_helper'

class OrdersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @new_user = users(:new_user)
    @yamada = users(:yamada)
    @buy_new_computer = orders(:buy_new_computer)
    @customer_mint = customers(:mint)
    @sato = users(:sato)
    @gala = products(:gala)
  end

  test "can't access not setup user" do
    sign_in(@new_user)

    get orders_path
    assert_redirected_to mysetting_path
    follow_redirect!
    assert_not flash[:notice].empty?
  end

  test "can't access not signin user" do
    get orders_path
    assert_redirected_to new_user_session_path
  end

  test "listing order" do
    sign_in(@yamada)

    get orders_path
    assert_response :success
    assert_select 'a[href=?]', edit_order_path(@buy_new_computer)
    assert_select 'div.pagination', count: 0
  end

  test "search order" do
    sign_in(@sato)

    get orders_path
    assert_response :success
    assert_select 'div.pagination', count: 1
    assert_select 'tbody>tr', count: 20

    get orders_path, params: { query: 'タクシー' }
    assert_response :success
    assert_select 'div.pagination', count: 0
    assert_select 'tbody>tr', count: 1
    assert_select 'input[value=?]', 'タクシー'
  end

  test "add new order" do
    sign_in(@sato)

    get orders_path
    assert_response :success
    assert_select 'a[href=?]', new_order_path

    get new_order_path
    assert_response :success
    assert_select 'input[type=?]', 'submit'

    # miss post (detail zero)
    assert_no_difference('Order.count') do
      post orders_path, params: { order: { title: '新しいバスの導入',
                                           customer_id: @customer_mint.id,
                                           order_no: '20180619',
                                           issue_date: Time.zone.now.to_s,
                                           due_date: Time.zone.now.to_s,
                                           payment_term: '月末締め翌々月現金払い',
                                           tax_rate: 0.08,
                                           remarks: '3年間無料点検サポートつき',
                                           user_profile_id: @sato.id,
                                           submitted_flag: false } }
    end
    assert_response :success
    assert_select '#error_explanation'

    # miss post (empty payment_term)
    assert_no_difference('Order.count') do
      post orders_path, params: { order: { title: '新しいバスの導入',
                                           customer_id: @customer_mint.id,
                                           order_no: '20180619',
                                           issue_date: Time.zone.now.to_s,
                                           due_date: Time.zone.now.to_s,
                                           payment_term: '',
                                           tax_rate: 0.08,
                                           remarks: '3年間無料点検サポートつき',
                                           user_profile_id: @sato.id,
                                           submitted_flag: false,
                                           order_details_attributes: [
                                             {
                                               display_order: 1,
                                               product_id: @gala.id,
                                               product_name: 'GALA',
                                               quantity: 2,
                                               unit_price: 6800000
                                             },
                                             {
                                               display_order: 2,
                                               product_name: '出精値引き',
                                               quantity: 1,
                                               unit_price: -100000
                                             }
                                           ] } }
    end
    assert_response :success
    assert_select '#error_explanation'

    # correct post
    assert_difference('Order.count', 1) do
      post orders_path, params: { order: { title: '新しいバスの導入',
                                           customer_id: @customer_mint.id,
                                           order_no: '20180619',
                                           issue_date: Time.zone.now.to_s,
                                           due_date: Time.zone.now.to_s,
                                           payment_term: '月末締め翌々月現金払い',
                                           tax_rate: 0.08,
                                           remarks: '3年間無料点検サポートつき',
                                           user_profile_id: @sato.id,
                                           submitted_flag: false,
                                           order_details_attributes: [
                                             {
                                               display_order: 1,
                                               product_id: @gala.id,
                                               product_name: 'GALA',
                                               quantity: 2,
                                               unit_price: 6800000
                                             },
                                             {
                                               display_order: 2,
                                               product_name: '出精値引き',
                                               quantity: 1,
                                               unit_price: -100000
                                             }
                                           ] } }
    end
    assert_redirected_to Order.last
    follow_redirect!
    assert_not flash.empty?
  end

  test "edit order" do
    sign_in(@yamada)

    get orders_path
    assert_response :success
    assert_select 'a[href=?]', edit_order_path(@buy_new_computer)

    get edit_order_path(@buy_new_computer)
    assert_response :success

    # miss post (payment term must be presence)
    patch order_path(@buy_new_computer), params: { order: { payment_term: '' } }
    assert_response :success
    assert flash.empty?
    assert_select '#error_explanation'
    assert_not_equal @buy_new_computer.reload.payment_term, ''

    # correct post
    patch order_path(@buy_new_computer), params: { order: { payment_term: '当月末締め翌々月現金払い' } }
    assert_redirected_to order_path(@buy_new_computer)
    follow_redirect!
    assert_not flash.empty?
    assert_equal @buy_new_computer.reload.payment_term, '当月末締め翌々月現金払い'
  end

  test "destroy order" do
    sign_in(@yamada)

    get orders_path
    assert_response :success
    assert_select 'tbody>tr', count: 1

    assert_difference('Order.count', -1) do
      delete order_path(@buy_new_computer)
    end
    assert_redirected_to orders_path
    follow_redirect!
    assert_not flash.empty?

    assert_select 'tbody>tr', count: 0
  end

end
