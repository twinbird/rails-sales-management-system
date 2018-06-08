json.extract! prospect, :id, :title, :customer_id, :rank, :prospect_amount, :prospect_order_date, :prospect_earning_date, :distribute, :user_profile_id, :company_information_id, :created_at, :updated_at
json.url prospect_url(prospect, format: :json)
