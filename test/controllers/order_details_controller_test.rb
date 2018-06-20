require 'test_helper'

class OrderDetailsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @yamada = users(:yamada)
    @new_user = users(:new_user)
    @buy_new_computer = orders(:buy_new_computer)
    @buy_new_taxi = orders(:buy_new_taxi)
  end

  test "can't access not setup user" do
    sign_in(@new_user)

    get order_detail_path(@buy_new_computer)
    assert_redirected_to mysetting_path
    follow_redirect!
    assert_not flash[:notice].empty?
  end

  test "can't access not signin user" do
    get order_detail_path(@buy_new_computer)
    assert_redirected_to new_user_session_path
  end

  test "return details of existing order in json" do
    sign_in(@yamada)

    get order_detail_path(@buy_new_computer), as: :json
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal json[0]["id"], @buy_new_computer.order_details[0].id
    assert_equal json[0]["display_order"], @buy_new_computer.order_details[0].display_order
    assert_equal json[0]["product_name"], @buy_new_computer.order_details[0].product_name
    assert_equal json[0].size, 3
  end

end
