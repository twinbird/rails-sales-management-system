class DropUnuseTables < ActiveRecord::Migration[5.1]
  def change
    drop_table :delivery_slip_details
    drop_table :delivery_slips
    drop_table :earnings
    drop_table :order_details
    drop_table :orders
    drop_table :closing_groups
  end
end
