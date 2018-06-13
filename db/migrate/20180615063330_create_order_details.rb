class CreateOrderDetails < ActiveRecord::Migration[5.1]
  def change
    create_table :order_details do |t|
      t.references :order, foreign_key: true
      t.integer :display_order
      t.references :product, foreign_key: true
      t.string :product_name
      t.decimal :quantity
      t.decimal :unit_price

      t.timestamps
    end
  end
end
