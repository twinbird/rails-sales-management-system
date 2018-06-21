class CreateCompanyInformations < ActiveRecord::Migration[5.1]
  def change
    create_table :company_informations, comment: '企業情報' do |t|
      t.string :name, null: false, default: '', comment: '会社名'

      t.timestamps
    end
  end
end
