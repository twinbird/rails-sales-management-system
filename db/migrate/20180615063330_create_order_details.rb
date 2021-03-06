class CreateOrderDetails < ActiveRecord::Migration[5.1]
  def change
    create_table :order_details, comment: '注文明細' do |t|
      t.references :order, foreign_key: true, comment: '受注ID'
      t.integer :display_order, null: false, default: 0, comment: '表示順'
      t.references :product, foreign_key: true, comment: '商品ID'
      t.string :product_name, null: false, default: '', comment: '商品名'
      t.decimal :quantity, null: false, default: 0, comment: '数量'
      t.decimal :unit_price, null: false, default: 0, comment: '単価'

      t.timestamps
    end
  end
end
