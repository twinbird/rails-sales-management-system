require 'test_helper'

class DeliverySlipsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @new_user = users(:new_user)
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
end
