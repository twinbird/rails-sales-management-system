class CreateDeliverySlips < ActiveRecord::Migration[5.1]
  def change
    create_table :delivery_slips do |t|
      t.references :company_information, foreign_key: true
      t.references :order, foreign_key: true
      t.date :delivery_date
      t.decimal :tax_rate
      t.references :user_profile, foreign_key: true
      t.text :remarks
      t.boolean :submitted_flag

      t.timestamps
    end
  end
end
