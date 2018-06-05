json.extract! customer, :id, :name, :payment_term, :company_information_id, :created_at, :updated_at
json.url customer_url(customer, format: :json)
