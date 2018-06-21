class Earning < ApplicationRecord
  belongs_to :company_information
  belongs_to :order

  validates :occur_date, presence: true
  validates :amount, presence: true, numericality: { greater_than: -1000000000, less_than: 1000000000 }

  scope :search, -> (word) {
    joins(:order).where("orders.title LIKE :word", word: "\%#{word}\%")
  }
end
