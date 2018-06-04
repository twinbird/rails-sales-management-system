class User < ApplicationRecord
  has_one :user_profile

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
