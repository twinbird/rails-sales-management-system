class User < ApplicationRecord
  has_one :user_profile, dependent: :destroy
  accepts_nested_attributes_for :user_profile

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def disable
    update(disabled_at: Time.zone.now)
  end

  def active_for_authentication?
    !disabled_at
  end
end
