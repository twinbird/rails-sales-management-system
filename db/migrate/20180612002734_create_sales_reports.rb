class CreateSalesReports < ActiveRecord::Migration[5.1]
  def change
    create_table :sales_reports do |t|
      t.references :company_information, foreign_key: true
      t.references :customer, foreign_key: true
      t.references :user_profile, foreign_key: true
      t.datetime :occur_date
      t.text :description

      t.timestamps
    end
  end
end
