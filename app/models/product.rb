class Product < ApplicationRecord
  belongs_to :company_information
  has_many :estimate_details, dependent: :restrict_with_error

  validates :name, presence: true, length: { maximum: 50 }
  validates :default_price, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 100000000 }

  scope :ours, -> (user) {
    where(company_information: user.user_profile.company_information)
  }

  scope :search, -> (word) {
    where("name LIKE :word", word: "\%#{word}\%")
  }
end
