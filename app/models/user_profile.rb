class UserProfile < ApplicationRecord
  belongs_to :user
  belongs_to :company_information

  validates :name, presence: true, length: { maximum: 50 }
end
