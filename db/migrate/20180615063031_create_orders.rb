class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.references :company_information, foreign_key: true
      t.references :prospect, foreign_key: true
      t.references :estimate, foreign_key: true
      t.string :title
      t.references :customer, foreign_key: true
      t.string :customer_name
      t.string :order_no
      t.date :issue_date
      t.date :due_date
      t.string :payment_term
      t.decimal :tax_rate
      t.text :remarks
      t.references :user_profile, foreign_key: true
      t.boolean :submitted_flag

      t.timestamps
    end
  end
end
