class CreateUserProfiles < ActiveRecord::Migration[5.1]
  def change
    create_table :user_profiles do |t|
      t.string :name
      t.references :user, foreign_key: true
      t.references :company_information, foreign_key: true

      t.timestamps
    end
  end
end
