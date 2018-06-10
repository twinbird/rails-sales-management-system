json.extract! product, :id, :name, :default_price, :company_information_id, :created_at, :updated_at
json.url product_url(product, format: :json)
