class Customer < ApplicationRecord
  belongs_to :company_information
  has_many :sales_reports, dependent: :restrict_with_error
  has_many :prospects, dependent: :restrict_with_error
  has_many :estimates, dependent: :restrict_with_error

  validates :name, presence: true, length: { maximum: 50 }
  validates :payment_term, length: { maximum: 50 }

  scope :search, -> (word) {
    where("name LIKE :word", word: "\%#{word}\%")
  }

  def latest_prospects(limit_size)
    prospects.order(created_at: :desc).limit(limit_size)
  end

  def latest_sales_reports(limit_size)
    sales_reports.order(occur_date: :desc).limit(limit_size)
  end

  def latest_estimates(limit_size)
    estimates.order(issue_date: :desc).limit(limit_size)
  end

end
