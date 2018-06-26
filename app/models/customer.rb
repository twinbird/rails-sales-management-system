class Customer < ApplicationRecord
  belongs_to :company_information
  has_many :sales_reports, dependent: :restrict_with_error
  has_many :prospects, dependent: :restrict_with_error
  has_many :estimates, dependent: :restrict_with_error

  validates :name, presence: true, length: { maximum: 50 }
  validates :payment_term, length: { maximum: 50 }

  scope :ours, -> (user) {
    where(company_information: user.user_profile.company_information)
  }
  scope :search, -> (word) {
    where("name LIKE :word", word: "\%#{word}\%")
  }
end
