require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @miyagi = users(:miyagi)
    @yamada = users(:yamada)
    @sato = users(:sato)
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

  test "last_user? should be false exist other user" do
    assert_not @sato.last_user?
  end

  test "last_user? should be true not exist other user" do
    assert @yamada.last_user?
  end

  test "last user must not disable" do
    assert_not @yamada.disable
    assert_nil @yamada.disabled_at
  end
end
