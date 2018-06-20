class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products, comment: '商品' do |t|
      t.string :name, null: false, default: '', comment: '品名'
      t.decimal :default_price, null: false, default: 0, comment: '標準単価'
      t.references :company_information, foreign_key: true, comment: '企業情報ID'

      t.timestamps
    end
  end
end
