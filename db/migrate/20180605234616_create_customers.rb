class CreateCustomers < ActiveRecord::Migration[5.1]
  def change
    create_table :customers, comment: '顧客' do |t|
      t.string :name, null: false, default: '', comment: '顧客名'
      t.string :payment_term, null: false, default: '', comment: '支払条件'
      t.references :company_information, foreign_key: true, comment: '企業情報ID'

      t.timestamps
    end
  end
end
