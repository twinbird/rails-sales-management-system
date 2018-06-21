class AddDescriptionToProspects < ActiveRecord::Migration[5.1]
  def change
    add_column :prospects, :description, :string, null: false, default: '', comment: '説明文'
  end
end
