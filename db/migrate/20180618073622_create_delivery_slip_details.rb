class CreateDeliverySlipDetails < ActiveRecord::Migration[5.1]
  def change
    create_table :delivery_slip_details do |t|
      t.integer :display_order
      t.references :delivery_slip, foreign_key: true
      t.references :order_detail, foreign_key: true

      t.timestamps
    end
  end
end
