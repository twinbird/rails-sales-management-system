class CreateDeliverySlipDetails < ActiveRecord::Migration[5.1]
  def change
    create_table :delivery_slip_details, comment: '納品明細' do |t|
      t.integer :display_order, null: false, default: 0, comment: '明細表示順'
      t.references :delivery_slip, foreign_key: true, comment: '納品ID'
      t.references :order_detail, foreign_key: true, comment: '受注明細ID'

      t.timestamps
    end
  end
end
