class AddOrderedFlag < ActiveRecord::Migration[5.1]
  def change
    add_column :estimates, :ordered_flag, :boolean, null: false, default: false
  end
end
