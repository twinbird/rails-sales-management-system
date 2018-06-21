class CreateSalesReports < ActiveRecord::Migration[5.1]
  def change
    create_table :sales_reports, comment: '営業報告' do |t|
      t.references :company_information, foreign_key: true, comment: '企業情報ID'
      t.references :customer, foreign_key: true, comment: '顧客ID'
      t.references :user_profile, foreign_key: true, comment: 'ユーザ情報ID'
      t.datetime :occur_date, comment: '活動日'
      t.string :description, null: false, default: '', comment: '報告内容'

      t.timestamps
    end
  end
end
