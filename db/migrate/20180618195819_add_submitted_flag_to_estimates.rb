class AddSubmittedFlagToEstimates < ActiveRecord::Migration[5.1]
  def change
    add_column :estimates, :submitted_flag, :boolean
  end
end
