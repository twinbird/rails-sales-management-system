class CompanyInformation < ApplicationRecord
  has_many :user_profiles, dependent: :destroy
  has_many :customers, dependent: :destroy
  has_many :prospects, dependent: :destroy
  has_many :estimates, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :sales_reports, dependent: :destroy
  accepts_nested_attributes_for :user_profiles

  validates :name, presence: true, length: { maximum: 50 }
  validates :last_estimate_no, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
