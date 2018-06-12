class EstimateDetail < ApplicationRecord
  belongs_to :estimate
  belongs_to :product, optional: true

  validates :display_order, presence: true
  validates :product_name, presence: true, length: { maximum: 50 }
  validates :quantity, presence: true, numericality: { greater_than: 0, less_than: 1000 }
  validates :unit_price, presence: true, numericality: { greater_than: -1000000000, less_than: 1000000000 }

  def price
    return 0 if quantity.nil? or unit_price.nil?
    quantity * unit_price
  end

end
