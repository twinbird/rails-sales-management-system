class CreateEstimates < ActiveRecord::Migration[5.1]
  def change
    create_table :estimates, comment: '見積' do |t|
      t.references :company_information, foreign_key: true, comment: '企業情報ID'
      t.references :prospect, foreign_key: true, comment: '案件ID'
      t.string :title, null: false, default: '', comment: '見積名'
      t.references :customer, foreign_key: true, comment: '顧客ID'
      t.string :customer_name, null: false, default: '', comment: '発行時顧客名'
      t.string :estimate_no, null: false, default: '', comment: '見積番号'
      t.date :issue_date, comment: '発行日'
      t.date :due_date, comment: '納期'
      t.boolean :due_date_pending_flag, null: false, default: false, comment: '納期は別途相談'
      t.string :payment_term, null: false, default: '', comment: '支払条件'
      t.date :effective_date, comment: '見積有効期限'
      t.decimal :tax_rate, null: false, default: 0, comment: '発行時消費税率'
      t.string :remarks, null: false, default: '', comment: '備考'
      t.references :user_profile, foreign_key: true, comment: '担当ユーザID'

      t.timestamps
    end
  end
end
