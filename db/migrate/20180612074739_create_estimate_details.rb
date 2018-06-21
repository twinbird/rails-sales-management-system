class CreateEstimateDetails < ActiveRecord::Migration[5.1]
  def change
    create_table :estimate_details, comment: '見積明細' do |t|
      t.references :estimate, foreign_key: true, comment: '見積ID'
      t.integer :display_order, null: false, default: 0, comment: '明細表示順'
      t.references :product, foreign_key: true, comment: '商品ID'
      t.string :product_name, null: false, default: '', comment: '商品名'
      t.decimal :quantity, null: false, default: 0, comment: '数量'
      t.decimal :unit_price, null: false, default: 0, comment: '単価'

      t.timestamps
    end
  end
end
