require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @miyagi = users(:miyagi)
  end

  test "disable must be update dissabled_at" do
    assert_nil @miyagi.disabled_at
    @miyagi.disable
    assert_not_nil @miyagi.disabled_at
  end

  test "active_for_authentication? must be false on disabled user" do
    assert_nil @miyagi.disabled_at
    assert @miyagi.active_for_authentication?

    @miyagi.disable
    assert_not_nil @miyagi.disabled_at
    assert_not @miyagi.active_for_authentication?
  end
end
