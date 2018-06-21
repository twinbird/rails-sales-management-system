class CreateProspects < ActiveRecord::Migration[5.1]
  def change
    create_table :prospects, comment: '案件' do |t|
      t.string :title, null: false, default: '', comment: '案件名'
      t.references :customer, foreign_key: true, comment: '顧客ID'
      t.integer :rank, null: false, default: 0, comment: '商談ランク'
      t.decimal :prospect_amount, null: false, default: 0, comment: '案件想定金額'
      t.datetime :prospect_order_date, comment: '注文予定日'
      t.datetime :prospect_earning_date, comment: '売上予定日'
      t.string :distribute, null: false, default: '', comment: '商流'
      t.references :user_profile, foreign_key: true, comment: '担当者ID'
      t.references :company_information, foreign_key: true, comment: '企業情報ID'

      t.timestamps
    end
  end
end
