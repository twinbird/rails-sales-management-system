require 'test_helper'

class CompanyInformationTest < ActiveSupport::TestCase

  def setup
    @lime = company_informations(:lime)
  end

  test "should be pass" do
    assert @lime.valid?
  end

  test "name must be present" do
    @lime.name = ""
    assert_not @lime.valid?
  end

  test "name must be less than 50" do
    @lime.name = "a" * 51
    assert_not @lime.valid?
  end

  test "last_estimate_no should not be nil" do
    @lime.last_estimate_no = nil
    assert_not @lime.valid?
  end

  test "last_estimate_no should be greater than or equal 0" do
    @lime.last_estimate_no = -1
    assert_not @lime.valid?
  end

  test "postal code should be presence on update" do
    @lime.postal_code = ""
    assert_not @lime.valid?
  end

  test "address1 should be presence on update" do
    @lime.address1 = ""
    assert_not @lime.valid?
  end

  test "address2 allow empty" do
    @lime.address2 = ""
    assert @lime.valid?
  end

  test "tel should be presence on update" do
    @lime.tel = ""
    assert_not @lime.valid?
  end

  test "fax allow empty" do
    @lime.fax = ""
    assert @lime.valid?
  end

  test "email allow empty" do
    @lime.email = ""
    assert @lime.valid?
  end

  test "postal code length must be less than 9" do
    @lime.postal_code = "999-99999"
    assert_not @lime.valid?
  end

  test "address1 length must be less than 51" do
    @lime.address1 = "a" * 50
    assert @lime.valid?

    @lime.address1 = "a" * 51
    assert_not @lime.valid?
  end

  test "address2 length must be less than 51" do
    @lime.address2 = "a" * 50
    assert @lime.valid?

    @lime.address2 = "a" * 51
    assert_not @lime.valid?
  end

  test "email length must be less than 41" do
    @lime.email = "a" * 28 + "@example.com"
    assert @lime.valid?

    @lime.email = "a" * 29 + "@example.com"
    assert_not @lime.valid?
  end

  test "tel length must be less than 21" do
    @lime.tel = "a" * 20
    assert @lime.valid?

    @lime.tel = "a" * 21
    assert_not @lime.valid?
  end

  test "fax length must be less than 21" do
    @lime.fax = "a" * 20
    assert @lime.valid?

    @lime.fax = "a" * 21
    assert_not @lime.valid?
  end

  test "email must be valid format" do
    @lime.email = "tt@example@.com"
    assert_not @lime.valid?
  end

end
