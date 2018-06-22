require 'test_helper'

class ClosingGroupTest < ActiveSupport::TestCase

  setup do
    @closing_by_10th = closing_groups(:closing_by_10th)
  end

  test "should be pass" do
    assert @closing_by_10th.valid?
  end

  test "name must be present" do
    @closing_by_10th.name = ""
    assert_not @closing_by_10th.valid?
  end

  test "name must be less than 21" do
    @closing_by_10th.name = "a" * 21
    assert_not @closing_by_10th.valid?

    @closing_by_10th.name = "a" * 20
    assert @closing_by_10th.valid?
  end

  test "name must be unique by each company" do
    closing_group = ClosingGroup.new
    closing_group.company_information = @closing_by_10th.company_information
    closing_group.name = @closing_by_10th.name

    assert_not closing_group.valid?
  end

end
