require 'test_helper'

class UserProfileTest < ActiveSupport::TestCase

  def setup
    @yamada = user_profiles(:yamada)
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

end
