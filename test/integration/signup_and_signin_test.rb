require 'test_helper'

class SignupAndSigninTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "signup and transition" do
    get new_user_registration_path
    assert_response :success

    post user_registration_path, params: { company_name: 'test company',
                                           user: { email: 'test@example.com',
                                                   password: 'password',
                                                   password_confirmation: 'password',
                                                   user_profile_attributes: {
                                                     name: 'test user'
                                                   } } }
    assert_redirected_to sales_reports_path
    follow_redirect!
    assert_not flash[:notice].empty?
    assert_select 'a', text: 'サインアウト', count: 1
  end

  test "signup with wrong info" do
    get new_user_registration_path
    assert_response :success

    # wrong email address
    post user_registration_path, params: { user: { email: 'test@@example.com',
                                                   password: 'password',
                                                   password_confirmation: 'password' } }
    assert_response :success
    assert_select 'a', text: 'サインアウト', count: 0

    # wrong password confirmation
    post user_registration_path, params: { user: { email: 'test@example.com',
                                                   password: 'password',
                                                   password_confirmation: 'password2' } }
    assert_response :success
    assert_select 'a', text: 'サインアウト', count: 0

    # password less than 5 chars
    post user_registration_path, params: { user: { email: 'test@example.com',
                                                   password: 'passw',
                                                   password_confirmation: 'passw' } }
    assert_response :success
    assert_select 'a', text: 'サインアウト', count: 0
  end

end
