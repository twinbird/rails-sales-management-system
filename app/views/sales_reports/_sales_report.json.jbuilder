json.extract! sales_report, :id, :customer_id, :user_profile_id, :occur_date, :description, :created_at, :updated_at
json.url sales_report_url(sales_report, format: :json)
