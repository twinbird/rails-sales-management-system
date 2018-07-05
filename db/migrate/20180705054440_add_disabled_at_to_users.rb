class AddDisabledAtToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :disabled_at, :datetime, default: nil
  end
end
