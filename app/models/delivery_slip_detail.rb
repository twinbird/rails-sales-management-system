class DeliverySlipDetail < ApplicationRecord
  belongs_to :delivery_slip
  belongs_to :order_detail

  validates :display_order, presence: true, numericality: { greater_than: 0, less_than: 11 }
end
