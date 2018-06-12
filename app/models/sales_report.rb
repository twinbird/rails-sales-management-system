class SalesReport < ApplicationRecord
  belongs_to :company_information
  belongs_to :customer
  belongs_to :user_profile

  validates :description, presence: true, length: { maximum: 1000 }
  validates :occur_date, presence: true

  scope :search, -> (word) {
    joins(:user_profile).joins(:customer).where("description LIKE :word OR customers.name LIKE :word OR user_profiles.name LIKE :word", word: "\%#{word}\%")
  }
end
