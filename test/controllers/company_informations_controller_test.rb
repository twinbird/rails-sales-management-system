require 'test_helper'

class CompanyInformationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @sato = users(:sato)
  end

  test "update with invalid company name" do
    sign_in(@sato)

    get edit_company_information_path(@sato.user_profile.company_information)
    assert_response :success

    # empty name
    patch company_information_path(@sato.user_profile.company_information),
      params: { company_information: { name: '' } }

    assert_response :success
    assert_select '#error_explanation', count: 1

    # too long name
    patch company_information_path(@sato.user_profile.company_information),
      params: { company_information: { name: 'a' * 51 } }

    assert_response :success
    assert_select '#error_explanation', count: 1
  end

  test "expect self company access other company" do
    sign_in(@sato)

    lemon = company_informations(:lemon)

    get edit_company_information_path(lemon)

    assert_response :success
    assert_select 'input[value=?]', @sato.user_profile.company_information.name
  end

end
