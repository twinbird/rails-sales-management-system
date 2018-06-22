class ClosingGroup < ApplicationRecord
  belongs_to :company_information

  validates :name, presence: true, length: { maximum: 20 }, uniqueness: { scope: [:company_information, :name] }
end
