class ChangeDatetimeToDate < ActiveRecord::Migration[5.1]
  def change
    change_column :prospects, :prospect_order_date, :date
    change_column :prospects, :prospect_earning_date, :date
    change_column :sales_reports, :occur_date, :date
  end
end
