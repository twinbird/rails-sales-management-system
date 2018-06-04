require 'test_helper'

class CompanyInformationTest < ActiveSupport::TestCase

  def setup
    @company_information = CompanyInformation.new
    @company_information.name = "lime company.co.ltd"
  end

  test "should be pass" do
    assert @company_information.valid?
  end

  test "name must be present" do
    @company_information.name = ""
    assert_not @company_information.valid?
  end

  test "name must be less than 50" do
    @company_information.name = "a" * 51
    assert_not @company_information.valid?
  end

end
