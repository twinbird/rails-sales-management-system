require 'test_helper'

class EstimatesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @yamada = users(:yamada)
    @sato = users(:sato)
    @buy_new_computer = estimates(:buy_new_computer)
    @buy_new_taxi_prospect = prospects(:buy_new_taxi)
    @customer_mint = customers(:mint)
    @crown = products(:crown)
    @non_ordered_estimate = estimates(:non_ordered_estimate)
    @misstake_estimate = estimates(:misstake_estimate)
  end

  test "can't access not signin user" do
    get estimates_path
    assert_redirected_to new_user_session_path
  end

  test "listing estimate" do
    sign_in(@yamada)

    get estimates_path
    assert_response :success
    assert_select 'nav.pagination', count: 1
  end

  test "search estimate" do
    sign_in(@sato)

    get estimates_path
    assert_response :success

    get estimates_path, params: { query: 'タクシー' }
    assert_response :success
    assert_select 'nav.pagination', count: 0
    assert_select 'tbody>tr', count: 1
    assert_select 'input[value=?]', 'タクシー'
  end

  test "add new estimate" do
    sign_in(@sato)

    get estimates_path
    assert_response :success
    assert_select 'a[href=?]', new_estimate_path

    get new_estimate_path
    assert_response :success
    assert_select 'input[type=?]', 'submit'

    # miss post (detail zero)
    assert_no_difference('Estimate.count') do
      post estimates_path, params: { estimate: { prospect_id: @buy_new_taxi_prospect.id,
                                                 title: '新タクシー導入',
                                                 customer_id: @customer_mint.id,
                                                 estimate_no: '20180614',
                                                 issue_date: Time.zone.now.to_s,
                                                 due_date: Time.zone.now.to_s,
                                                 due_date_pending_flag: false,
                                                 payment_term: '月末締め翌々月現金払い',
                                                 effective_date: Time.zone.now.next_month,
                                                 tax_rate: 0.08,
                                                 submitted_flag: false,
                                                 remarks: '冬タイヤは含まない' } }
    end
    assert_response :success
    assert flash.empty?

    # correct post
    assert_difference('Estimate.count', 1) do
      post estimates_path, params: { estimate: { prospect_id: @buy_new_taxi_prospect.id,
                                                 title: '新タクシー導入',
                                                 customer_id: @customer_mint.id,
                                                 estimate_no: '20180614',
                                                 issue_date: Time.zone.now.to_s,
                                                 due_date: Time.zone.now.to_s,
                                                 due_date_pending_flag: false,
                                                 payment_term: '月末締め翌々月現金払い',
                                                 effective_date: Time.zone.now.next_month,
                                                 tax_rate: 0.08,
                                                 remarks: '冬タイヤは含まない',
                                                 user_profile_id: @sato.id,
                                                 submitted_flag: false,
                                                 estimate_details_attributes: [
                                                   {
                                                     display_order: 1,
                                                     product_id: @crown.id,
                                                     product_name: 'クラウン',
                                                     quantity: 4,
                                                     unit_price: 4000000
                                                   }
                                                 ] } }
    end
    assert_redirected_to Estimate.last
    follow_redirect!
    assert_not flash.empty?
  end

  test "edit estimate" do
    sign_in(@yamada)

    get estimates_path, params: { query: @buy_new_computer.title }
    assert_response :success
    assert_select 'a[href=?]', estimate_path(@buy_new_computer)

    get estimate_path(@buy_new_computer)
    assert_response :success

    assert_select 'a[href=?]', edit_estimate_path(@buy_new_computer)
    get edit_estimate_path(@buy_new_computer)
    assert_response :success

    # miss post (payment term must be presence)
    patch estimate_path(@buy_new_computer), params: { estimate: { payment_term: '' } }
    assert_not_equal @buy_new_computer.reload.payment_term, ''
    assert_response :success
    assert flash.empty?

    # correct post
    patch estimate_path(@buy_new_computer), params: { estimate: { payment_term: '当月末締め翌々月現金払い' } }
    assert_equal @buy_new_computer.reload.payment_term, '当月末締め翌々月現金払い'
    assert_redirected_to estimate_path(@buy_new_computer)
    follow_redirect!

    assert_not flash.empty?
  end

  test "destroy estimate" do
    sign_in(@yamada)

    get estimates_path, params: { query: @misstake_estimate.title }
    assert_response :success

    assert_select 'a[href=?]', estimate_path(@misstake_estimate)
    get estimate_path(@misstake_estimate)
    assert_response :success

    assert_select 'a[href=?]', estimate_path(@misstake_estimate)

    assert_difference('Estimate.count', -1) do
      delete estimate_path(@misstake_estimate)
    end
    assert_redirected_to estimates_path
    follow_redirect!
    assert_not flash.empty?
  end

  test "can not destroy submitted estimate" do
    sign_in(@yamada)

    get estimates_path, params: { query: @buy_new_computer.title }
    assert_response :success
    assert_select 'tbody>tr', count: 1

    assert_select 'a[href=?]', estimate_path(@buy_new_computer)
    get estimate_path(@buy_new_computer)
    assert_response :success

    assert_select 'a[href=?]', estimate_path(@buy_new_computer), count: 0

    assert_no_difference('Estimate.count') do
      delete estimate_path(@buy_new_computer)
    end
    assert_redirected_to estimates_path
    follow_redirect!
    assert_not flash.empty?

    get estimates_path, params: { query: @buy_new_computer.title }
    assert_response :success
    assert_select 'tbody>tr', count: 1
  end

  test "can not destroy ordered estimate" do
    sign_in(@yamada)

    get estimates_path, params: { query: @buy_new_computer.title }
    assert_response :success
    assert_select 'tbody>tr', count: 1

    @buy_new_computer.submitted_flag = false
    @buy_new_computer.save

    assert_select 'a[href=?]', estimate_path(@buy_new_computer)
    get estimate_path(@buy_new_computer)
    assert_response :success

    assert_select 'a[href=?]', estimate_path(@buy_new_computer), count: 0

    assert_no_difference('Estimate.count') do
      delete estimate_path(@buy_new_computer)
    end
    assert_redirected_to estimates_path
    follow_redirect!
    assert_not flash.empty?

    get estimates_path, params: { query: @buy_new_computer.title }
    assert_response :success
    assert_select 'tbody>tr', count: 1
  end

  test "should 404 access other company estimate" do
    sign_in(@sato)

    assert_raise(ActiveRecord::RecordNotFound) do
      get estimate_path(@buy_new_computer)
    end
  end

end
