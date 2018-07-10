class AddUniqueIndexToEstimateNo < ActiveRecord::Migration[5.1]
  def change
    add_index :estimates, [:company_information_id, :estimate_no], unique: true
  end
end
