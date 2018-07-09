json.extract! customer, :id, :name, :payment_term
json.url customer_url(customer, format: :json)
