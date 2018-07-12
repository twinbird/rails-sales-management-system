class AddCompanyInformationToEstimates < ActiveRecord::Migration[5.1]
  def change
    add_column :estimates, :company_name, :string, null: false, default: '', comment: '発行時の自社名'
    add_column :estimates, :postal_code, :string, null: false, default: '', comment: '発行時の自社郵便番号'
    add_column :estimates, :address1, :string, null: false, default: '', comment: '発行時の自社住所1'
    add_column :estimates, :address2, :string, null: false, default: '', comment: '発行時の自社住所2'
    add_column :estimates, :email, :string, null: false, default: '', comment: '発行時の自社メールアドレス'
    add_column :estimates, :tel, :string, null: false, default: '', comment: '発行時の自社電話番号'
    add_column :estimates, :fax, :string, null: false, default: '', comment: '発行時の自社FAX番号'
  end
end
