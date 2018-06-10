class CompanyInformation < ApplicationRecord
  has_many :user_profiles, dependent: :destroy
  has_many :customers, dependent: :destroy
  has_many :prospects, dependent: :destroy
  has_many :products, dependent: :destroy
  accepts_nested_attributes_for :user_profiles

  validates :name, presence: true, length: { maximum: 50 }
end
