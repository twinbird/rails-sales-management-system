require 'test_helper'

class UserProfilesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @miyagi = users(:miyagi)
    @disabled_user = user_profiles(:disabled_user)
    @yamada = users(:yamada)
  end

  test "can't access not signin user" do
    get user_profiles_path
    assert_redirected_to new_user_session_path
  end

  test "listing pagination" do
    sign_in(@miyagi)

    get user_profiles_path
    assert_response :success
    assert_select 'nav.pagination'
  end

  test "search list" do
    sign_in(@miyagi)

    get user_profiles_path, params: { query: '宮城' }
    assert_response :success
    assert_select 'nav.pagination', count: 0
    assert_select 'tbody>tr', count: 1
  end

  test "add new user with valid info" do
    sign_in(@miyagi)

    get user_profiles_path
    assert_response :success
    assert_select 'a[href=?]', new_user_profile_path

    get new_user_profile_path
    assert_response :success

    post user_profiles_path, params: { user: { email: 'test@example.com',
                                               password: 'password',
                                               password_confirmation: 'password',
                                               user_profile_attributes: {
                                                 name: 'test'
                                               } } }
    assert_redirected_to user_profiles_url
    follow_redirect!
    assert_not flash[:info].empty?
  end

  test "add new user with invalid info" do
    sign_in(@miyagi)

    get user_profiles_path
    assert_response :success
    assert_select 'a[href=?]', new_user_profile_path

    get new_user_profile_path
    assert_response :success

    post user_profiles_path, params: { user: { email: 'test@example.com',
                                               password: 'password',
                                               password_confirmation: 'passwordd',
                                               user_profile_attributes: {
                                                 name: 'test'
                                               } } }
    assert_response :success
    assert_select '#error_explanation'
  end

  test "add new user with invalid profile info" do
    sign_in(@miyagi)

    get user_profiles_path
    assert_response :success
    assert_select 'a[href=?]', new_user_profile_path

    get new_user_profile_path
    assert_response :success

    post user_profiles_path, params: { user: { email: 'test@example.com',
                                               password: 'password',
                                               password_confirmation: 'password',
                                               user_profile_attributes: {
                                                 name: ''
                                               } } }
    assert_response :success
    assert_select '#error_explanation'
  end

  test "user disable" do
    sign_in(@miyagi)

    get user_profiles_path, params: { query: @miyagi.email }
    assert_response :success
    assert_select 'a[href=?]', user_profile_path(@miyagi.user_profile)

    delete user_profile_path(@miyagi.user_profile)
    assert_redirected_to user_profiles_path
    assert_not flash[:info].empty?
  end

  test "last user must not be disable" do
    sign_in(@yamada)

    get user_profiles_path
    assert_response :success
    assert_select 'a[href=?]', user_profile_path(@yamada.user_profile), count: 0

    delete user_profile_path(@yamada.user_profile)
    assert_redirected_to user_profiles_path
    follow_redirect!
    assert_not flash[:danger].empty?

    assert_nil @yamada.reload.disabled_at
  end

  test "disable user shouldn't listing" do
    sign_in(@miyagi)

    get user_profiles_path, params: { query: @disabled_user.name }
    assert_response :success
    assert_select 'a[href=?]', user_profile_path(@disabled_user), count: 0
  end

end
