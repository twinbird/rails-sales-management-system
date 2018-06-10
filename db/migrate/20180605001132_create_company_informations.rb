class CreateCompanyInformations < ActiveRecord::Migration[5.1]
  def change
    create_table :company_informations do |t|
      t.string :name

      t.timestamps
    end
  end
end
