class CompanyInformation < ApplicationRecord
  has_many :user_profiles, dependent: :destroy
  has_many :customers, dependent: :destroy
  has_many :prospects, dependent: :destroy
  has_many :estimates, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :sales_reports, dependent: :destroy
  accepts_nested_attributes_for :user_profiles

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, presence: true, length: { maximum: 50 }
  validates :postal_code, presence: true, on: :update
  validates :postal_code, length: { maximum: 8 }
  validates :address1, presence: true, on: :update
  validates :address1, length: { maximum: 50 }
  validates :address2, length: { maximum: 50 }
  validates :email, length: { maximum: 40 }
  validates :email, format: { with: VALID_EMAIL_REGEX }, allow_blank: true
  validates :tel, presence: true, on: :update
  validates :tel, length: { maximum: 20 }
  validates :fax, length: { maximum: 20 }
  validates :last_estimate_no, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
