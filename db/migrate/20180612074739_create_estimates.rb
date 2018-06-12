class CreateEstimates < ActiveRecord::Migration[5.1]
  def change
    create_table :estimates do |t|
      t.references :company_information, foreign_key: true
      t.references :prospect, foreign_key: true
      t.string :title
      t.references :customer, foreign_key: true
      t.string :customer_name
      t.string :estimate_no
      t.date :issue_date
      t.date :due_date
      t.boolean :due_date_pending_flag
      t.string :payment_term
      t.date :effective_date
      t.decimal :tax_rate
      t.text :remarks
      t.references :user_profile, foreign_key: true

      t.timestamps
    end
  end
end
