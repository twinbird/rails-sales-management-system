class CreateCustomers < ActiveRecord::Migration[5.1]
  def change
    create_table :customers do |t|
      t.string :name
      t.string :payment_term
      t.references :company_information, foreign_key: true

      t.timestamps
    end
  end
end
