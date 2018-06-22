require 'test_helper'

class ClosingGroupsControllerTest < ActionDispatch::IntegrationTest
=begin
  setup do
    @closing_group = closing_groups(:one)
  end

  test "should get index" do
    get closing_groups_url
    assert_response :success
  end

  test "should get new" do
    get new_closing_group_url
    assert_response :success
  end

  test "should create closing_group" do
    assert_difference('ClosingGroup.count') do
      post closing_groups_url, params: { closing_group: { company_information_id: @closing_group.company_information_id, name: @closing_group.name } }
    end

    assert_redirected_to closing_group_url(ClosingGroup.last)
  end

  test "should show closing_group" do
    get closing_group_url(@closing_group)
    assert_response :success
  end

  test "should get edit" do
    get edit_closing_group_url(@closing_group)
    assert_response :success
  end

  test "should update closing_group" do
    patch closing_group_url(@closing_group), params: { closing_group: { company_information_id: @closing_group.company_information_id, name: @closing_group.name } }
    assert_redirected_to closing_group_url(@closing_group)
  end

  test "should destroy closing_group" do
    assert_difference('ClosingGroup.count', -1) do
      delete closing_group_url(@closing_group)
    end

    assert_redirected_to closing_groups_url
  end
=end
end
