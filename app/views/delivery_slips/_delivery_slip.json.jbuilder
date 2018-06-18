json.extract! delivery_slip, :id, :company_information_id, :order_id, :delivery_date, :remarks, :created_at, :updated_at
json.url delivery_slip_url(delivery_slip, format: :json)
