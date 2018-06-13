# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180615063330) do

  create_table "company_informations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "customers", force: :cascade do |t|
    t.string "name"
    t.string "payment_term"
    t.integer "company_information_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_information_id"], name: "index_customers_on_company_information_id"
  end

  create_table "estimate_details", force: :cascade do |t|
    t.integer "estimate_id"
    t.integer "display_order"
    t.integer "product_id"
    t.string "product_name"
    t.decimal "quantity"
    t.decimal "unit_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["estimate_id"], name: "index_estimate_details_on_estimate_id"
    t.index ["product_id"], name: "index_estimate_details_on_product_id"
  end

  create_table "estimates", force: :cascade do |t|
    t.integer "company_information_id"
    t.integer "prospect_id"
    t.string "title"
    t.integer "customer_id"
    t.string "customer_name"
    t.string "estimate_no"
    t.date "issue_date"
    t.date "due_date"
    t.boolean "due_date_pending_flag"
    t.string "payment_term"
    t.date "effective_date"
    t.decimal "tax_rate"
    t.text "remarks"
    t.integer "user_profile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_information_id"], name: "index_estimates_on_company_information_id"
    t.index ["customer_id"], name: "index_estimates_on_customer_id"
    t.index ["prospect_id"], name: "index_estimates_on_prospect_id"
    t.index ["user_profile_id"], name: "index_estimates_on_user_profile_id"
  end

  create_table "order_details", force: :cascade do |t|
    t.integer "order_id"
    t.integer "display_order"
    t.integer "product_id"
    t.string "product_name"
    t.decimal "quantity"
    t.decimal "unit_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_details_on_order_id"
    t.index ["product_id"], name: "index_order_details_on_product_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "company_information_id"
    t.integer "prospect_id"
    t.integer "estimate_id"
    t.string "title"
    t.integer "customer_id"
    t.string "customer_name"
    t.string "order_no"
    t.date "issue_date"
    t.date "due_date"
    t.string "payment_term"
    t.decimal "tax_rate"
    t.text "remarks"
    t.integer "user_profile_id"
    t.boolean "submitted_flag"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_information_id"], name: "index_orders_on_company_information_id"
    t.index ["customer_id"], name: "index_orders_on_customer_id"
    t.index ["estimate_id"], name: "index_orders_on_estimate_id"
    t.index ["prospect_id"], name: "index_orders_on_prospect_id"
    t.index ["user_profile_id"], name: "index_orders_on_user_profile_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.decimal "default_price"
    t.integer "company_information_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_information_id"], name: "index_products_on_company_information_id"
  end

  create_table "prospects", force: :cascade do |t|
    t.string "title"
    t.integer "customer_id"
    t.integer "rank"
    t.decimal "prospect_amount"
    t.datetime "prospect_order_date"
    t.datetime "prospect_earning_date"
    t.string "distribute"
    t.integer "user_profile_id"
    t.integer "company_information_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.index ["company_information_id"], name: "index_prospects_on_company_information_id"
    t.index ["customer_id"], name: "index_prospects_on_customer_id"
    t.index ["user_profile_id"], name: "index_prospects_on_user_profile_id"
  end

  create_table "sales_reports", force: :cascade do |t|
    t.integer "company_information_id"
    t.integer "customer_id"
    t.integer "user_profile_id"
    t.datetime "occur_date"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_information_id"], name: "index_sales_reports_on_company_information_id"
    t.index ["customer_id"], name: "index_sales_reports_on_customer_id"
    t.index ["user_profile_id"], name: "index_sales_reports_on_user_profile_id"
  end

  create_table "user_profiles", force: :cascade do |t|
    t.string "name"
    t.integer "user_id"
    t.integer "company_information_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_information_id"], name: "index_user_profiles_on_company_information_id"
    t.index ["user_id"], name: "index_user_profiles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
