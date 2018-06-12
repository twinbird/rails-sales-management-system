class CreateEstimateDetails < ActiveRecord::Migration[5.1]
  def change
    create_table :estimate_details do |t|
      t.references :estimate, foreign_key: true
      t.integer :display_order
      t.references :product, foreign_key: true
      t.string :product_name
      t.decimal :quantity
      t.decimal :unit_price

      t.timestamps
    end
  end
end
