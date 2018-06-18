class CompanyInformation < ApplicationRecord
  has_many :user_profiles, dependent: :destroy
  has_many :customers, dependent: :destroy
  has_many :prospects, dependent: :destroy
  has_many :estimates, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :sales_reports, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :delivery_slips, dependent: :destroy
  accepts_nested_attributes_for :user_profiles

  validates :name, presence: true, length: { maximum: 50 }
end
