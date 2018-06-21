class CreateEarnings < ActiveRecord::Migration[5.1]
  def change
    create_table :earnings do |t|
      t.references :company_information, foreign_key: true, comment: '企業情報ID'
      t.references :order, foreign_key: true, comment: '注文ID'
      t.date :occur_date, null: false, comment: '売上日'
      t.decimal :amount, null: false, default: 0, comment: '売上金額'

      t.timestamps
    end
  end
end
