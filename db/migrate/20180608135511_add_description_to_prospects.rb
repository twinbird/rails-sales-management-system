class AddDescriptionToProspects < ActiveRecord::Migration[5.1]
  def change
    add_column :prospects, :description, :text
  end
end
