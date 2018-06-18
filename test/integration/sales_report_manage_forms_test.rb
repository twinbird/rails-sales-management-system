require 'test_helper'

class SalesReportManageFormsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @sato = users(:sato)
    @yamada = users(:yamada)
    @new_user = users(:new_user)
    @pepper = customers(:pepper)
    @sales_to_pepper = sales_reports(:sales_to_pepper)
    @sales_to_mint = sales_reports(:sales_to_mint)
  end

  test "can't access not setup user" do
    sign_in(@new_user)

    get sales_reports_path
    assert_redirected_to mysetting_path
    follow_redirect!
    assert_not flash[:notice].empty?
  end

  test "can't access not signin user" do
    get sales_reports_path
    assert_redirected_to new_user_session_path
  end

  test "add new sales report" do
    sign_in(@sato)

    get sales_reports_path
    assert_response :success
    assert_select 'a[href=?]', new_sales_report_path

    get new_sales_report_path
    assert_response :success
    assert_select 'form[action=?]', sales_reports_path

    post sales_reports_path, params: { sales_report: { customer_id: @pepper.id,
                                                       user_profile_id: @sato.id,
                                                       occur_date: Time.zone.now,
                                                       description: "this is sales report" } }
    follow_redirect!
    assert_not flash.empty?
    assert_match /this is sales report/, response.body
  end

  test "edit sales report" do
    sign_in(@yamada)

    get sales_reports_path
    assert_response :success
    assert_select 'a[href=?]', edit_sales_report_path(@sales_to_mint)

    get edit_sales_report_path(@sales_to_mint)
    assert_response :success
    assert_select 'form[action=?]', sales_report_path(@sales_to_mint)

    patch sales_report_path(@sales_to_mint), params: { sales_report: { description: "sales report!" } }
    assert_redirected_to sales_report_path(@sales_to_mint)
    follow_redirect!

    assert_not flash.empty?
    assert_match /sales report!/, response.body
  end

  test "destroy sales report" do
    sign_in(@yamada)

    get sales_reports_path
    assert_response :success

    assert_select 'a[href=?]', sales_report_path(@sales_to_mint), count: 2

    delete sales_report_path(@sales_to_mint)
    assert_redirected_to sales_reports_path
    follow_redirect!

    assert_not flash.empty?
  end

  test "listing sales report" do
    sign_in(@sato)
    get sales_reports_path
    assert_response :success
    assert_select 'div.pagination'
    sign_out(@sato)

    sign_in(@yamada)
    get sales_reports_path
    assert_response :success
    assert_select 'div.pagination', count: 0
  end

  test "search sales report" do
    sign_in(@sato)

    # non specify query
    get sales_reports_path
    assert_response :success
    assert_select 'tbody>tr', count: 20

    # specify user name
    get sales_reports_path, params: { query: '田中' }
    assert_response :success
    assert_select 'tbody>tr', count: 1
    assert_select 'input[value=?]', '田中'

    # specify partial customer name
    get sales_reports_path, params: { query: 'peppe' }
    assert_response :success
    assert_select 'tbody>tr', count: 20
    assert_select 'input[value=?]', 'peppe'

    # specify partial description
    get sales_reports_path, params: { query: 'XX商談に' }
    assert_response :success
    assert_select 'tbody>tr', count: 1
    assert_select 'input[value=?]', 'XX商談に'

    # specify other customer name
    get sales_reports_path, params: { query: 'ミント株式会社' }
    assert_response :success
    assert_select 'tbody>tr', count: 0
    assert_select 'input[value=?]', 'ミント株式会社'
  end

end
