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
  validate :details_count_validate

  MIN_DETAILS_SIZE = 1
  MAX_DETAILS_SIZE = 10

  scope :search, -> (word) {
    joins(:order).joins(order: :customer).where("orders.title LIKE :word OR customers.name LIKE :word", word: "\%#{word}\%")
  }

  private

    def details_count_validate
      errors.add(:delivery_slip_details, 'too many details') if delivery_slip_details.size > MAX_DETAILS_SIZE
      errors.add(:delivery_slip_details, 'too few details') if delivery_slip_details.size < MIN_DETAILS_SIZE
    end

end
