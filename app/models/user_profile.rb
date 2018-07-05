class UserProfile < ApplicationRecord
  belongs_to :user
  belongs_to :company_information
  has_many :sales_report, dependent: :restrict_with_error
  has_many :estimate, dependent: :restrict_with_error
  has_many :prospect, dependent: :restrict_with_error

  validates :name, presence: true, length: { maximum: 50 }

  scope :actives, -> {
    joins(:user).where("users.disabled_at IS NULL")
  }

  scope :search, -> (word) {
    joins(:user).where("name LIKE :word OR users.email LIKE :word", word: "\%#{word}\%")
  }
end
