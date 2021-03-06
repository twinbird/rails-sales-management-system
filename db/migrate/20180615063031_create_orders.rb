class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders, comment: '注文' do |t|
      t.references :company_information, foreign_key: true, comment: '企業情報ID'
      t.references :prospect, foreign_key: true, comment: '案件ID'
      t.references :estimate, foreign_key: true, comment: '見積ID'
      t.string :title, null: false, default: '', comment: '注文名'
      t.references :customer, foreign_key: true, comment: '顧客ID'
      t.string :customer_name, null: false, default: '', comment: '発行時顧客名'
      t.string :order_no, null: false, default: '', comment: '注文番号'
      t.date :issue_date, comment: '発行日'
      t.date :due_date, comment: '納期'
      t.string :payment_term, null: false, default: '', comment: '支払条件'
      t.decimal :tax_rate, null: false, default: 0, comment: '発行時消費税率'
      t.string :remarks, null: false, default: '', comment: '備考'
      t.references :user_profile, foreign_key: true, comment: '発行担当者ID'
      t.boolean :submitted_flag, null: false, default: false, comment: '顧客へ提出済'

      t.timestamps
    end
  end
end
