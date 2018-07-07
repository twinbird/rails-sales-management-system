class User < ApplicationRecord
  has_one :user_profile, dependent: :destroy
  accepts_nested_attributes_for :user_profile

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def disable
    if last_user?
      errors.add(:name, I18n.t('is_last_user_last_user_can_not_disable'))
      return false
    end
    update(disabled_at: Time.zone.now)
  end

  def active_for_authentication?
    !disabled_at
  end

  def last_user?
    return true if self.user_profile.nil?
    return true if self.user_profile.company_information.nil?
    self.user_profile.company_information.user_profiles.count == 1
  end
end
