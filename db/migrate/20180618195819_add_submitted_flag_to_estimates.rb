class AddSubmittedFlagToEstimates < ActiveRecord::Migration[5.1]
  def change
    add_column :estimates, :submitted_flag, :boolean, null: false, default: false, comment: '顧客へ提出済'
  end
end
