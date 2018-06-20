class CreateDeliverySlips < ActiveRecord::Migration[5.1]
  def change
    create_table :delivery_slips, comment: '納品' do |t|
      t.references :company_information, foreign_key: true, comment: '企業情報ID'
      t.references :order, foreign_key: true, comment: '受注ID'
      t.date :delivery_date, comment: '納品日'
      t.decimal :tax_rate, null: false, default: 0, comment: '納品時適用消費税率'
      t.references :user_profile, foreign_key: true, comment: '発行ユーザID'
      t.string :remarks, null: false, default: '', comment: '備考'
      t.boolean :submitted_flag, null: false, default: false, comment: '顧客へ提出済'

      t.timestamps
    end
  end
end
