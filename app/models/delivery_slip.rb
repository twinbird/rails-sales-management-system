class DeliverySlip < ApplicationRecord
  belongs_to :company_information
  belongs_to :order
  belongs_to :user_profile
  has_many :delivery_slip_details, dependent: :destroy
  accepts_nested_attributes_for :delivery_slip_details, allow_destroy: true, limit: 10

  validates :delivery_date, presence: true
  validates :tax_rate, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 1 }
  validates :remarks, length: { maximum: 1000 }
  validates :submitted_flag, inclusion: { in: [true, false] }

  scope :search, -> (word) {
    joins(:order).joins(order: :customer).where("orders.title LIKE :word OR customers.name LIKE :word", word: "\%#{word}\%")
  }
end
