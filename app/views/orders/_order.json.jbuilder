json.extract! order, :id, :company_information_id, :prospect_id, :estimate_id, :title, :customer_id, :customer_name, :order_no, :issue_date, :due_date, :payment_term, :tax_rate, :remarks, :user_profile_id, :submitted_flag, :created_at, :updated_at
json.url order_url(order, format: :json)
