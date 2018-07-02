require 'csv'

CSV.generate(encoding: Encoding::SJIS, row_sep: "\r\n", force_quotes: true) do |csv|
  csv_column_names = %w[顧客名 支払条件]
  csv << csv_column_names
  @customers.each do |customer|
    csv_column_values = [
      customer.name,
      customer.payment_term
    ]
    csv << csv_column_values
  end
end
