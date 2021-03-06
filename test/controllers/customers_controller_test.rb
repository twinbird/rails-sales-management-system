require 'test_helper'
require 'csv'
require 'json'

class CustomersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  include ActionDispatch::TestProcess

  def setup
    @yamada = users(:yamada)
    @sato = users(:sato)
    @pepper = customers(:pepper)
    @mint = customers(:mint)
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

  test "csv download is equal search result" do
    sign_in(@sato)

    get customers_path, params: { query: '0' }
    assert_response :success
    assert_select 'tbody>tr', count: 9

    expect_csv = CSV.generate(encoding: Encoding::SJIS, row_sep: "\r\n", force_quotes: true) do |csv|
      csv << %w[顧客名 支払条件]
      90.times do |i|
        next if i % 10 != 0
        customer = customers("customer#{i}".to_sym)
        csv_column_values = [
          customer.name,
          customer.payment_term
        ]
        csv << csv_column_values
      end
    end

    get customers_path(format: :csv), params: { query: '0' }
    assert_response :success
    assert_equal expect_csv.encode("UTF-8"), response.body.encode("UTF-8")
  end

  test "valid csv import" do
    sign_in(@sato)

    get customers_path
    assert_response :success
    assert_select 'a[href=?]', import_form_customers_path

    get import_form_customers_path
    assert_response :success
    assert_select 'form[action=?]', import_customers_path

    file = fixture_file_upload "files/customer.csv", "text/comma-separated-values"
    assert_difference('Customer.count', 4) do
      post import_customers_path, params: { file: file }
    end
    assert_response :success
    assert_not flash[:notice].empty?
  end

  test "invalid csv import" do
    sign_in(@sato)

    get customers_path
    assert_response :success
    assert_select 'a[href=?]', import_form_customers_path

    get import_form_customers_path
    assert_response :success
    assert_select 'form[action=?]', import_customers_path

    file = fixture_file_upload "files/error_customer.csv", "text/comma-separated-values"
    assert_no_difference('Customer.count') do
      post import_customers_path, params: { file: file }
    end
    assert_response :success
    assert_select '#error_explanation'
    assert flash.empty?
  end

  test "json customer api found customer" do
    sign_in(@sato)

    get customer_path(@pepper, format: :json)
    assert_response :success

    json = JSON(response.body)
    assert_equal 4, json.size
    assert_equal @pepper.id, json["id"]
    assert_equal @pepper.name, json["name"]
    assert_equal @pepper.payment_term, json["payment_term"]
    assert_equal customer_url(@pepper, format: :json), json["url"]
  end

  test "json customer api not found customer" do
    sign_in(@yamada)

    assert_raise(ActiveRecord::RecordNotFound) do
      get customer_path(@pepper, format: :json)
    end
  end

  test "should 404 access other company customer" do
    sign_in(@yamada)

    assert_raise(ActiveRecord::RecordNotFound) do
      get customer_path(@pepper)
    end
  end

end
