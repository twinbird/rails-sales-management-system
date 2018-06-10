class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :name
      t.decimal :default_price
      t.references :company_information, foreign_key: true

      t.timestamps
    end
  end
end
