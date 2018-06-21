class CreateUserProfiles < ActiveRecord::Migration[5.1]
  def change
    create_table :user_profiles, comment: 'ユーザ' do |t|
      t.string :name, null: false, default: '', comment: 'ユーザ名'
      t.references :user, foreign_key: true, comment: 'ユーザID'
      t.references :company_information, foreign_key: true, comment: '企業情報ID'

      t.timestamps
    end
  end
end
