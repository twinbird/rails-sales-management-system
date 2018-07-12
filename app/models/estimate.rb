require 'bigdecimal'

class Estimate < ApplicationRecord
  belongs_to :company_information
  belongs_to :prospect, optional: true
  belongs_to :customer
  belongs_to :user_profile
  has_many :estimate_details, dependent: :destroy
  accepts_nested_attributes_for :estimate_details, allow_destroy: true, limit: 10
  before_validation :save_customer_name
  before_validation :set_estimate_no
  before_validation :set_company_information, on: :create
  before_destroy :can_destroy?
  after_initialize :set_default_tax_rate

  MIN_DETAILS_SIZE = 1
  MAX_DETAILS_SIZE = 10
  DEFAULT_TAX_RATE = 8

  validates :title, presence: true, length: { maximum: 70 }
  validates :customer, presence: true
  validates :customer_name, presence: true, length: { maximum: 50 }
  validates :estimate_no, presence: true, length: { maximum: 14 }, uniqueness: { scope: [:company_information_id, :estimate_no] }
  validates :issue_date, presence: true
  validates :due_date, presence: true, unless: :due_date_pending_flag
  validates :due_date_pending_flag, inclusion: { in: [true, false] }
  validates :payment_term, presence: true, length: { maximum: 50 }
  validates :effective_date, presence: true
  validates :tax_rate, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 100 }
  validates :remarks, length: { maximum: 1000 }
  validate :details_count_validate
  validates :submitted_flag, inclusion: { in: [true, false] }
  validates :ordered_flag, inclusion: { in: [true, false] }

  scope :search, -> (word) {
    joins(:customer).joins(:user_profile).where("title LIKE :word OR customers.name LIKE :word OR user_profiles.name LIKE :word", word: "\%#{word}\%")
  }

  private

    def details_count_validate
      errors.add(:estimate_details, 'too_many_details') if estimate_details.size > MAX_DETAILS_SIZE
      errors.add(:estimate_details, 'too_few_details') if estimate_details.size < MIN_DETAILS_SIZE
    end

    def save_customer_name
      return if customer.blank?
      self[:customer_name] = customer.name
    end

    def can_destroy?
      if submitted_flag
        errors.add(:base, '.can_not_destroy_submitted_estimate')
        throw :abort
      end
      if ordered_flag
        errors.add(:base, '.can_not_destroy_ordered_estimate')
        throw :abort
      end
    end

    def set_default_tax_rate
      return if persisted?
      self.tax_rate = DEFAULT_TAX_RATE
    end

    def set_estimate_no
      return if persisted?
      company_information.increment(:last_estimate_no)
      eno = sprintf("%014d", company_information.last_estimate_no)
      self.estimate_no = eno
    end

    def set_company_information
      self.company_name = company_information.name
      self.postal_code = company_information.postal_code
      self.address1 = company_information.address1
      self.address2 = company_information.address2
      self.email = company_information.email
      self.tel = company_information.tel
      self.fax = company_information.fax
    end

end
