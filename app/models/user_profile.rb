class UserProfile < ApplicationRecord
  belongs_to :user
  belongs_to :company_information
  has_many :sales_report, dependent: :restrict_with_error
  has_many :prospect, dependent: :restrict_with_error

  validates :name, presence: true, length: { maximum: 50 }

  scope :ours, -> (user) {
    where(company_information: user.user_profile.company_information)
  }
end
