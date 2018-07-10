class AddLastEstimateNoToCompanyInformations < ActiveRecord::Migration[5.1]
  def change
    add_column :company_informations, :last_estimate_no, :integer, null: false, default: 0
  end
end
