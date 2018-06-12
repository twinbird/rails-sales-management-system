class Estimate < ApplicationRecord
  belongs_to :company_information
  belongs_to :prospect, optional: true
  belongs_to :customer
  belongs_to :user_profile
  has_many :estimate_details, dependent: :destroy
  accepts_nested_attributes_for :estimate_details, allow_destroy: true, limit: 10
  before_validation :save_customer_name

  MIN_DETAILS_SIZE = 1
  MAX_DETAILS_SIZE = 10

  validates :title, presence: true, length: { maximum: 70 }
  validates :customer_name, presence: true, length: { maximum: 50 }
  validates :estimate_no, presence: true, length: { maximum: 14 }
  validates :issue_date, presence: true
  validates :due_date, presence: true, unless: :due_date_pending_flag
  validates :due_date_pending_flag, inclusion: { in: [true, false] }
  validates :payment_term, presence: true, length: { maximum: 50 }
  validates :effective_date, presence: true
  validates :tax_rate, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 1 }
  validates :remarks, length: { maximum: 1000 }
  validate :details_count_validate

  scope :search, -> (word) {
    joins(:customer).joins(:user_profile).where("title LIKE :word OR customers.name LIKE :word OR user_profiles.name LIKE :word", word: "\%#{word}\%")
  }

  private

    def details_count_validate
      errors.add(:estimate_details, 'too_many_details') if estimate_details.size > MAX_DETAILS_SIZE
      errors.add(:estimate_details, 'too_few_details') if estimate_details.size < MIN_DETAILS_SIZE
    end

    def save_customer_name
      self.customer_name = customer.name
    end

end
