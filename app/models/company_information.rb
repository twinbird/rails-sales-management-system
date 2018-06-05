class CompanyInformation < ApplicationRecord
  has_many :user_profiles
  has_many :customers
  accepts_nested_attributes_for :user_profiles

  validates :name, presence: true, length: { maximum: 50 }
end
