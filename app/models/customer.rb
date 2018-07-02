require 'csv'

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

  def self.import(file, company)
    ret = nil
    Customer.transaction do
      CSV.foreach(file.path, encoding: 'sjis', headers: true).with_index(2) do |row, i|
        obj = new
        obj.company_information = company
        obj.name = row.to_hash[I18n.t('activerecord.attributes.customer.name')]
        obj.payment_term = row.to_hash[I18n.t('activerecord.attributes.customer.payment_term')]

        ret = [i, obj]
        obj.save!
      end
    end
  rescue ActiveRecord::RecordInvalid
    return ret
  end

end
