require 'test_helper'

class MysettingTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @sato = users(:sato)
    @new_user = users(:new_user)
  end

  test "create with invalid company name" do
    sign_in(@new_user)

    get mysetting_path
    assert_response :success

    # empty name
    post company_informations_path, params: { company_information: { name: '',
                                                                     user_profiles_attributes: { '0': { name: 'test' } } } }
    assert_response :success
    assert_select '#error_explanation', count: 1

    # too long name
    post company_informations_path, params: { company_information: { name: 'a' * 51,
                                                                     user_profiles_attributes: { '0': { name: 'test' } } } }
    assert_response :success
    assert_select '#error_explanation', count: 1
  end

  test "create with invalid user name" do
    sign_in(@new_user)

    get mysetting_path
    assert_response :success

    # empty name
    post company_informations_path, params: { company_information: { name: 'test',
                                                                     user_profiles_attributes: { '0': { name: '' } } } }
    assert_response :success
    assert_select '#error_explanation', count: 1

    # too long name
    post company_informations_path, params: { company_information: { name: 'test',
                                                                     user_profiles_attributes: { '0': { name: 'a' * 51 } } } }
    assert_response :success
    assert_select '#error_explanation', count: 1
  end

  test "update with invalid company name" do
    sign_in(@sato)

    get mysetting_path
    assert_response :success

    # empty name
    patch company_information_path(@sato.user_profile.company_information),
      params: { company_information: { name: '',
                                       user_profiles_attributes: { '0': { name: 'test' } } } }
    assert_response :success
    assert_select '#error_explanation', count: 1

    # too long name
    patch company_information_path(@sato.user_profile.company_information),
      params: { company_information: { name: 'a' * 51,
                                       user_profiles_attributes: { '0': { name: 'test' } } } }
    assert_response :success
    assert_select '#error_explanation', count: 1
  end

  test "update with invalid user name" do
    sign_in(@sato)

    get mysetting_path
    assert_response :success

    # empty name
    patch company_information_path(@sato.user_profile.company_information),
      params: { company_information: { name: 'company',
                                       user_profiles_attributes: { '0': { name: '' } } } }
    assert_response :success
    assert_select '#error_explanation', count: 1

    # too long name
    patch company_information_path(@sato.user_profile.company_information),
      params: { company_information: { name: 'company',
                                       user_profiles_attributes: { '0': { name: 'a' * 51 } } } }
    assert_response :success
    assert_select '#error_explanation', count: 1
  end

end
