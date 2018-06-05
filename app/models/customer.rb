class Customer < ApplicationRecord
  belongs_to :company_information

  validates :name, presence: true, length: { maximum: 50 }
  validates :payment_term, length: { maximum: 50 }

  scope :ours, -> (user) {
    where(company_information: user.user_profile.company_information)
  }
end
