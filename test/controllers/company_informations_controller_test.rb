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

  test "update with valid information" do
    sign_in(@sato)

    get edit_company_information_path(@sato.user_profile.company_information)
    assert_response :success

    expect_name = "updated company name"
    expect_postal_code = "999-9999"
    expect_address1 = "xxx-yyyy-zzzz"
    expect_address2 = "aa 11-22"
    expect_email = "xxx@example.com"
    expect_tel = "090-0000-0000"
    expect_fax = "076-2222-2222"

    patch company_information_path(@sato.user_profile.company_information),
      params: { company_information: {
                  name: expect_name,
                  postal_code: expect_postal_code,
                  address1: expect_address1,
                  address2: expect_address2,
                  email: expect_email,
                  tel: expect_tel,
                  fax: expect_fax
              } }
    assert_response :success
    assert_not flash[:notice].empty?

    @sato.reload

    assert_equal expect_name, @sato.user_profile.company_information.name
    assert_equal expect_postal_code, @sato.user_profile.company_information.postal_code
    assert_equal expect_address1, @sato.user_profile.company_information.address1
    assert_equal expect_address2, @sato.user_profile.company_information.address2
    assert_equal expect_email, @sato.user_profile.company_information.email
    assert_equal expect_tel, @sato.user_profile.company_information.tel
    assert_equal expect_fax, @sato.user_profile.company_information.fax
  end

end
