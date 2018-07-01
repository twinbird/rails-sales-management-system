require 'test_helper'

class ProspectsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @sato = users(:sato)
    # yamada has many prospects
    @yamada = users(:yamada)
    @new_user = users(:new_user)
    @buy_new_taxi = prospects(:buy_new_taxi)
    @introduce_new_garage = prospects(:introduce_new_garage)
  end

  test "can't access not setup user" do
    sign_in(@new_user)

    get prospects_path
    assert_redirected_to mysetting_path
    follow_redirect!
    assert_not flash[:notice].empty?
  end

  test "can't access not signin user" do
    get prospects_path
    assert_redirected_to new_user_session_path
  end

  test "add new prospect" do
    sign_in(@sato)

    get prospects_path
    assert_response :success
    assert_select 'a[href=?]', new_prospect_path

    get new_prospect_path
    assert_response :success
    assert_select 'form[action=?]', prospects_path

    # input miss
    assert_no_difference('Prospect.count') do
      post prospects_path, params: { prospect: { title: '',
                                                 customer_id: customers(:pepper).id,
                                                 rank: 'A',
                                                 prospect_amount: 10000,
                                                 prospect_order_date: Time.zone.now.to_s,
                                                 prospect_earning_date: Time.zone.now.to_s,
                                                 distribute: "既存顧客",
                                                 user_profile_id: users(:sato).id } }
    end
    assert_response :success
    assert_select '#error_explanation', count: 1

    # valid input
    assert_difference('Prospect.count', 1) do
      post prospects_path, params: { prospect: { title: '案件1',
                                                 customer_id: customers(:pepper).id,
                                                 rank: 'A',
                                                 prospect_amount: 10000,
                                                 prospect_order_date: Time.zone.now.to_s,
                                                 prospect_earning_date: Time.zone.now.to_s,
                                                 distribute: "既存顧客",
                                                 user_profile_id: users(:sato).id } }
    end
    assert_redirected_to Prospect.last
    follow_redirect!
    assert_not flash.empty?

    assert_match /案件1/, response.body
  end

  test "edit prospect" do
    sign_in(@sato)

    get prospects_path
    assert_response :success
    assert_select 'a[href=?]', prospect_path(@buy_new_taxi)

    get prospect_path(@buy_new_taxi)
    assert_response :success
    assert_select 'a[href=?]', edit_prospect_path(@buy_new_taxi)

    get edit_prospect_path(@buy_new_taxi)
    assert_response :success

    # input miss
    patch prospect_path(@buy_new_taxi), params: { prospect: { title: '' } }
    assert_not_equal @buy_new_taxi.reload.title, ''
    assert_response :success
    assert_select '#error_explanation', count: 1

    # valid input
    patch prospect_path(@buy_new_taxi), params: { prospect: { title: '新車購入' } }

    assert_equal @buy_new_taxi.reload.title, '新車購入'
    assert_redirected_to prospect_path(@buy_new_taxi)
    follow_redirect!

    assert_not flash.empty?
  end

  test "can't destroy created estimate prospect" do
    sign_in(@sato)

    get prospects_path
    assert_response :success
    assert_select 'a[href=?]', prospect_path(@buy_new_taxi)

    assert_no_difference('Prospect.count') do
      delete prospect_path(@buy_new_taxi)
    end
    assert_redirected_to prospects_path
    follow_redirect!
    assert_select 'a[href=?]', prospect_path(@buy_new_taxi)
  end

  test "destroy prospect" do
    sign_in(@sato)

    get prospects_path
    assert_response :success
    assert_select 'a[href=?]', prospect_path(@introduce_new_garage)

    assert_difference('Prospect.count', -1) do
      delete prospect_path(@introduce_new_garage)
    end
    assert_redirected_to prospects_path
    follow_redirect!
    assert_select 'a[href=?]', prospect_path(@introduce_new_garage), count: 0
  end

  test "listing pagination" do
    sign_in(@yamada)

    get prospects_path
    assert_response :success
    assert_select 'nav.pagination'
  end

  test "search prospects" do
    sign_in(@yamada)

    get prospects_path
    assert_response :success
    assert_select 'tbody>tr', count: 20

    get prospects_path, params: { query: '営業所' }
    assert_response :success
    assert_select 'tbody>tr', count: 1
    assert_select 'input[value=?]', '営業所'
  end

  test "listing latest prospects" do
    sign_in(@sato)

    latest_prospects = @buy_new_taxi.customer.latest_prospects(5)
    get prospect_path(@buy_new_taxi)
    assert_response :success

    latest_prospects.each do |prospect|
      assert_select 'a[href=?]', prospect_path(prospect)
    end
  end

end
