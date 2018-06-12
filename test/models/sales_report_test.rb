require 'test_helper'

class SalesReportTest < ActiveSupport::TestCase

  def setup
    @sales_to_mint = sales_reports(:sales_to_mint)
  end

  test "should be pass" do
    assert @sales_to_mint.valid?
  end

  test "description must be presence" do
    @sales_to_mint.description = ""
    assert_not @sales_to_mint.valid?
  end

  test "description must be less than 1000" do
    @sales_to_mint.description = "a" * 1001
    assert_not @sales_to_mint.valid?
  end

  test "occur date must be presence" do
    @sales_to_mint.occur_date = nil
    assert_not @sales_to_mint.valid?
  end

end
