class Order < ApplicationRecord
  belongs_to :company_information
  belongs_to :prospect, optional: true
  belongs_to :estimate, optional: true
  belongs_to :customer
  belongs_to :user_profile
  has_many :order_details, dependent: :destroy
  accepts_nested_attributes_for :order_details, allow_destroy: true, limit: 10
  before_validation :set_customer_name

  MIN_DETAILS_SIZE = 1
  MAX_DETAILS_SIZE = 10

  validates :title, presence: true, length: { maximum: 70 }
  validates :customer_name, presence: true, length: { maximum: 50 }
  validates :order_no, presence: true, length: { maximum: 14 }
  validates :issue_date, presence: true
  validates :due_date, presence: true
  validates :payment_term, presence: true, length: { maximum: 50 }
  validates :tax_rate, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 1 }
  validates :remarks, length: { maximum: 1000 }
  validates :submitted_flag, inclusion: { in: [true, false] }
  validate :details_count_validate

  scope :search, -> (word) {
    joins(:customer).joins(:user_profile).where("title LIKE :word OR customers.name LIKE :word OR user_profiles.name LIKE :word", word: "\%#{word}\%")
  }

  private

    def details_count_validate
      errors.add(:order_details, 'too_many_details') if order_details.size > MAX_DETAILS_SIZE
      errors.add(:order_details, 'too_few_details') if order_details.size < MIN_DETAILS_SIZE
    end

    def set_customer_name
      self.customer_name = customer.name unless customer.nil?
    end
end
