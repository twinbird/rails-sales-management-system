class CreateClosingGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :closing_groups do |t|
      t.references :company_information, foreign_key: true, comment: '企業情報ID'
      t.string :name, null: false, default: '', comment: '締処理グループ名'

      t.timestamps
    end
    add_index :closing_groups, [:company_information_id, :name], unique: true
  end
end
