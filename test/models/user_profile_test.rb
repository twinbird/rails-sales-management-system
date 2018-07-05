require 'test_helper'

class UserProfileTest < ActiveSupport::TestCase

  def setup
    @yamada = user_profiles(:yamada)
    @disabled_user = user_profiles(:disabled_user)
  end

  test "should be pass" do
    assert @yamada.valid?
  end

  test "name must be present" do
    @yamada.name = ""
    assert_not @yamada.valid?
  end

  test "name must be less than 50" do
    @yamada.name = "a" * 51
    assert_not @yamada.valid?
  end

  test "search should match partial name or email" do
    profiles = UserProfile.search('user')
    assert_equal 100, profiles.count

    profiles = UserProfile.search('ユーザ')
    assert_equal 100, profiles.count

    profiles = UserProfile.search('not found')
    assert_equal 0, profiles.count
  end

  test "actives should return not disabled users" do
    assert_not_nil UserProfile.find_by(name: @disabled_user.name)
    assert_nil UserProfile.actives.find_by(name: @disabled_user.name)
  end

end
