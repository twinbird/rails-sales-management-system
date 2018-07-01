class UserProfile < ApplicationRecord
  belongs_to :user
  belongs_to :company_information
  has_many :sales_report, dependent: :restrict_with_error
  has_many :estimate, dependent: :restrict_with_error
  has_many :prospect, dependent: :restrict_with_error

  validates :name, presence: true, length: { maximum: 50 }
end
