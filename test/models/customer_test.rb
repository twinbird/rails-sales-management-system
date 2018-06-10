require 'test_helper'

class CustomerTest < ActiveSupport::TestCase

  def setup
    @customer = customers(:mint)
  end

  test "should be pass" do
    assert @customer.valid?
  end

  test "name must be present" do
    @customer.name = ""
    assert_not @customer.valid?
  end

  test "name must be less than 50" do
    @customer.name = "a" * 51
    assert_not @customer.valid?

    @customer.name = "a" * 50
    assert @customer.valid?
  end

  test "payment_term accept empty" do
    @customer.payment_term = ""
    assert @customer.valid?
  end

  test "payment_term must be less than 50" do
    @customer.payment_term = "a" * 51
    assert_not @customer.valid?

    @customer.payment_term = "a" * 50
    assert @customer.valid?
  end

end
