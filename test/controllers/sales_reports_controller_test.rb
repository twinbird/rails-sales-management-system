require 'test_helper'

class SalesReportsControllerTest < ActionDispatch::IntegrationTest
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

    # miss post(empty description)
    assert_no_difference('SalesReport.count') do
      post sales_reports_path, params: { sales_report: { customer_id: @pepper.id,
                                                         user_profile_id: @sato.id,
                                                         occur_date: Time.zone.now,
                                                         description: "" } }
    end
    assert_response :success
    assert_select '#error_explanation'

    # correct post
    assert_difference('SalesReport.count', 1) do
      post sales_reports_path, params: { sales_report: { customer_id: @pepper.id,
                                                         user_profile_id: @sato.id,
                                                         occur_date: Time.zone.now,
                                                         description: "this is sales report" } }
    end
    assert_redirected_to SalesReport.last
    follow_redirect!
    assert_not flash.empty?
    assert_match /this is sales report/, response.body
  end

  test "edit sales report" do
    sign_in(@yamada)

    get sales_reports_path
    assert_response :success
    assert_select 'a[href=?]', sales_report_path(@sales_to_mint)

    get sales_report_path(@sales_to_mint)
    assert_response :success
    assert_select 'a[href=?]', edit_sales_report_path(@sales_to_mint)

    get edit_sales_report_path(@sales_to_mint)
    assert_response :success
    assert_select 'form[action=?]', sales_report_path(@sales_to_mint)

    # miss post (description empty)
    patch sales_report_path(@sales_to_mint), params: { sales_report: { description: "" } }
    assert_response :success
    assert_select '#error_explanation'

    # correct post
    patch sales_report_path(@sales_to_mint), params: { sales_report: { description: "sales report!" } }
    assert_redirected_to sales_report_path(@sales_to_mint)
    follow_redirect!
    assert_equal @sales_to_mint.reload.description, "sales report!"
    assert_not flash.empty?
  end

  test "destroy sales report" do
    sign_in(@yamada)

    get sales_reports_path
    assert_response :success

    assert_select 'a[href=?]', sales_report_path(@sales_to_mint)

    assert_difference('SalesReport.count', -1) do
      delete sales_report_path(@sales_to_mint)
    end
    assert_redirected_to sales_reports_path
    follow_redirect!

    assert_not flash.empty?
  end

  test "listing sales report" do
    sign_in(@sato)
    get sales_reports_path
    assert_response :success
    assert_select 'nav.pagination'
    sign_out(@sato)

    sign_in(@yamada)
    get sales_reports_path
    assert_response :success
    assert_select 'nav.pagination', count: 0
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

  test "listing latest prospects" do
    sign_in(@sato)

    latest_prospects = @pepper.latest_prospects(5)
    get sales_report_path(@sales_to_pepper)
    assert_response :success

    latest_prospects.each do |prospect|
      assert_select 'a[href=?]', prospect_path(prospect)
    end
  end

  test "listing latest estimates" do
    sign_in(@sato)

    latest_estimates = @pepper.latest_estimates(5)
    get sales_report_path(@sales_to_pepper)
    assert_response :success

    latest_estimates.each do |estimate|
      assert_select 'a[href=?]', estimate_path(estimate)
    end
  end

end
