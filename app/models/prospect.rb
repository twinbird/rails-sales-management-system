class Prospect < ApplicationRecord
  belongs_to :customer
  belongs_to :user_profile
  belongs_to :company_information

  enum rank: { A: 0, B: 1, C: 2, D: 3 }

  validates :title, presence: true, length: { maximum: 50 }
  validates :rank, presence: true
  validates :distribute, length: { maximum: 100 }
end
