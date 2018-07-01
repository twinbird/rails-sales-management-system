require 'test_helper'

class ProductTest < ActiveSupport::TestCase

  def setup
    @crown = products(:crown)
  end

  test "should be pass" do
    assert @crown.valid?
  end

  test "name must be present" do
    @crown.name = ""
    assert_not @crown.valid?
  end

  test "name must be less than 50" do
    @crown.name = "a" * 51
    assert_not @crown.valid?
  end

  test "default_price must be present" do
    @crown.default_price = nil
    assert_not @crown.valid?
  end

  test "default_price must be greater than or equal 0" do
    @crown.default_price = -1
    assert_not @crown.valid?

    @crown.default_price = 0
    assert @crown.valid?
  end

  test "default_price must be less than 100000000" do
    @crown.default_price = 100000000
    assert_not @crown.valid?

    @crown.default_price = 99999999
    assert @crown.valid?
  end

  test "search should return only partial match product 'name'" do
    products = Product.search('product_')
    assert_equal 99, products.count

    one_found = Product.search('自動卵')
    assert_equal 1, one_found.count

    empty = Product.search('hoge foo bar')
    assert_equal 0, empty.count
  end

end
