require 'test_helper'

class DeliverySlipsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @sato = users(:sato)
    @new_user = users(:new_user)
    @delivered_order = delivery_slips(:delivered_order)
    @pending_delivery_order = orders(:pending_delivery_order)
  end

  test "can't access not setup user" do
    sign_in(@new_user)

    get delivery_slips_path
    assert_redirected_to mysetting_path
    follow_redirect!
    assert_not flash[:notice].empty?
  end

  test "can't access not signin user" do
    get delivery_slips_path
    assert_redirected_to new_user_session_path
  end

  test "listing delivery slips" do
    sign_in(@sato)

    get delivery_slips_path
    assert_response :success
    assert_select 'div.pagination'
  end

  test "search delivery slips" do
    sign_in(@sato)

    get delivery_slips_path
    assert_response :success
    assert_select 'div.pagination'

    get delivery_slips_path, params: { query: 'MacBook10台' }
    assert_response :success
    assert_select 'div.pagination', count: 0
    assert_select 'tbody>tr', count: 1
  end

  test "add new delivery slips" do
    sign_in(@sato)

    get delivery_slips_path
    assert_response :success
    assert_select 'a[href=?]', new_delivery_slip_path

    get new_delivery_slip_path
    assert_response :success

    # miss post (detail not input)
    assert_no_difference('DeliverySlip.count') do
      post delivery_slips_path, params: { delivery_slip: { order_id: @pending_delivery_order.id,
                                                           delivery_date: '2018-03-14',
                                                           remarks: '',
                                                           tax_rate: 0.08,
                                                           user_profile_id: @sato.id,
                                                           submitted_flag: true } }
    end

    # miss post (no specify order id)
    assert_no_difference('DeliverySlip.count') do
      post delivery_slips_path, params: { delivery_slip: { delivery_date: '2018-03-14',
                                                           remarks: '',
                                                           tax_rate: 0.08,
                                                           user_profile_id: @sato.id,
                                                           submitted_flag: true,
                                                           delivery_slip_details_attributes: [
                                                             {
                                                               display_order: 1,
                                                               order_detail_id: order_details(:pending_delivery_order_one).id
                                                             },
                                                             {
                                                               display_order: 2,
                                                               order_detail_id: order_details(:pending_delivery_order_two).id
                                                             }
                                                           ] } }
    end

    # correct post
    assert_difference('DeliverySlip.count', 1) do
      post delivery_slips_path, params: { delivery_slip: { order_id: @pending_delivery_order.id,
                                                           delivery_date: '2018-03-14',
                                                           remarks: '',
                                                           tax_rate: 0.08,
                                                           user_profile_id: @sato.id,
                                                           submitted_flag: true,
                                                           delivery_slip_details_attributes: [
                                                             {
                                                               display_order: 1,
                                                               order_detail_id: order_details(:pending_delivery_order_one).id
                                                             },
                                                             {
                                                               display_order: 2,
                                                               order_detail_id: order_details(:pending_delivery_order_two).id
                                                             }
                                                           ] } }
    end
    assert_redirected_to DeliverySlip.last
    assert_not flash.empty?
  end

  test "edit delivery slips" do
    sign_in(@sato)

    get delivery_slips_path, params: { query: 'MacBook10台' }
    assert_select 'a[href=?]', edit_delivery_slip_path(@delivered_order)

    get edit_delivery_slip_path(@delivered_order)
    assert_response :success

    # miss post (order id must be specify)
    patch delivery_slip_path(@delivered_order), params: { delivery_slip: { order_id: '' } }
    assert_response :success
    assert_not_equal @delivered_order.reload.order_id, ''

    # correct post
    patch delivery_slip_path(@delivered_order), params: { delivery_slip: { remarks: '' } }
    assert_redirected_to @delivered_order
    assert_equal @delivered_order.reload.remarks, ''
  end

  test "destroy delivery slips" do
    sign_in(@sato)

    get delivery_slips_path, params: { query: 'MacBook10台' }
    assert_select 'a[href=?]', delivery_slip_path(@delivered_order), count: 2

    assert_difference('DeliverySlip.count', -1) do
      delete delivery_slip_path(@delivered_order)
    end
    assert_redirected_to delivery_slips_path
  end

end
