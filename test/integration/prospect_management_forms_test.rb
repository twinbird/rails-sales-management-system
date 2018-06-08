require 'test_helper'

class ProspectManagementFormsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @sato = users(:sato)
    # yamada has many prospects
    @yamada = users(:yamada)
    @new_user = users(:new_user)
    @buy_new_computer = prospects(:buy_new_computer)
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
    post prospects_path, params: { prospect: { title: '',
                                               customer_id: customers(:pepper).id,
                                               rank: 'A',
                                               prospect_amount: 10000,
                                               prospect_order_date: DateTime.now.to_s,
                                               prospect_earning_date: DateTime.now.to_s,
                                               distribute: "既存顧客",
                                               user_profile_id: users(:sato).id } }
    assert_response :success
    assert_select '#error_explanation', count: 1

    # valid input
    post prospects_path, params: { prospect: { title: '案件1',
                                               customer_id: customers(:pepper).id,
                                               rank: 'A',
                                               prospect_amount: 10000,
                                               prospect_order_date: DateTime.now.to_s,
                                               prospect_earning_date: DateTime.now.to_s,
                                               distribute: "既存顧客",
                                               user_profile_id: users(:sato).id } }
    follow_redirect!
    assert_not flash.empty?

    assert_match /案件1/, response.body
  end

  test "edit prospect" do
    sign_in(@sato)

    get prospects_path
    assert_response :success
    assert_select 'a[href=?]', edit_prospect_path(@buy_new_computer)

    get edit_prospect_path(@buy_new_computer)
    assert_response :success

    # input miss
    patch prospect_path(@buy_new_computer), params: { prospect: { title: '' } }
    assert_response :success
    assert_select '#error_explanation', count: 1

    # valid input
    patch prospect_path(@buy_new_computer), params: { prospect: { title: '新車購入' } }

    assert_redirected_to prospect_path(@buy_new_computer)
    follow_redirect!

    assert_not flash.empty?
    assert_match /新車購入/, response.body
  end

  test "destroy prospect" do
    sign_in(@sato)

    get prospects_path
    assert_response :success
    assert_select 'a[href=?]', prospect_path(@buy_new_computer)

    delete prospect_path(@buy_new_computer)
    assert_redirected_to prospects_path
    follow_redirect!
    assert_select 'a[href=?]', prospect_path(@buy_new_computer), count: 0
  end

  test "listing pagination" do
    sign_in(@yamada)

    get prospects_path
    assert_response :success
    assert_select 'div.pagination'
  end

end
