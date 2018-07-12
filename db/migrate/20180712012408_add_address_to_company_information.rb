class AddAddressToCompanyInformation < ActiveRecord::Migration[5.1]
  def change
    add_column :company_informations, :postal_code, :string, null: false, default: '', comment: '自社の郵便番号'
    add_column :company_informations, :address1, :string, null: false, default: '', comment: '自社の住所1'
    add_column :company_informations, :address2, :string, null: false, default: '', comment: '自社の住所2'
    add_column :company_informations, :email, :string, null: false, default: '', comment: '自社のメールアドレス'
    add_column :company_informations, :tel, :string, null: false, default: '', comment: '自社の電話番号'
    add_column :company_informations, :fax, :string, null: false, default: '', comment: '自社のFAX番号'
  end
end
