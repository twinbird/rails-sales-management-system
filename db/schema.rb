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

ActiveRecord::Schema.define(version: 20180705054440) do

  create_table "company_informations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "企業情報" do |t|
    t.string "name", default: "", null: false, comment: "会社名"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "customers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "顧客" do |t|
    t.string "name", default: "", null: false, comment: "顧客名"
    t.string "payment_term", default: "", null: false, comment: "支払条件"
    t.bigint "company_information_id", comment: "企業情報ID"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_information_id"], name: "index_customers_on_company_information_id"
  end

  create_table "estimate_details", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "見積明細" do |t|
    t.bigint "estimate_id", comment: "見積ID"
    t.integer "display_order", default: 0, null: false, comment: "明細表示順"
    t.bigint "product_id", comment: "商品ID"
    t.string "product_name", default: "", null: false, comment: "商品名"
    t.decimal "quantity", precision: 10, default: "0", null: false, comment: "数量"
    t.decimal "unit_price", precision: 10, default: "0", null: false, comment: "単価"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["estimate_id"], name: "index_estimate_details_on_estimate_id"
    t.index ["product_id"], name: "index_estimate_details_on_product_id"
  end

  create_table "estimates", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "見積" do |t|
    t.bigint "company_information_id", comment: "企業情報ID"
    t.bigint "prospect_id", comment: "案件ID"
    t.string "title", default: "", null: false, comment: "見積名"
    t.bigint "customer_id", comment: "顧客ID"
    t.string "customer_name", default: "", null: false, comment: "発行時顧客名"
    t.string "estimate_no", default: "", null: false, comment: "見積番号"
    t.date "issue_date", comment: "発行日"
    t.date "due_date", comment: "納期"
    t.boolean "due_date_pending_flag", default: false, null: false, comment: "納期は別途相談"
    t.string "payment_term", default: "", null: false, comment: "支払条件"
    t.date "effective_date", comment: "見積有効期限"
    t.decimal "tax_rate", precision: 4, scale: 3, default: "0.0", null: false, comment: "発行時消費税率"
    t.string "remarks", default: "", null: false, comment: "備考"
    t.bigint "user_profile_id", comment: "担当ユーザID"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "submitted_flag", default: false, null: false, comment: "顧客へ提出済"
    t.boolean "ordered_flag", default: false, null: false
    t.index ["company_information_id"], name: "index_estimates_on_company_information_id"
    t.index ["customer_id"], name: "index_estimates_on_customer_id"
    t.index ["prospect_id"], name: "index_estimates_on_prospect_id"
    t.index ["user_profile_id"], name: "index_estimates_on_user_profile_id"
  end

  create_table "products", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "商品" do |t|
    t.string "name", default: "", null: false, comment: "品名"
    t.decimal "default_price", precision: 10, default: "0", null: false, comment: "標準単価"
    t.bigint "company_information_id", comment: "企業情報ID"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_information_id"], name: "index_products_on_company_information_id"
  end

  create_table "prospects", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "案件" do |t|
    t.string "title", default: "", null: false, comment: "案件名"
    t.bigint "customer_id", comment: "顧客ID"
    t.integer "rank", default: 0, null: false, comment: "商談ランク"
    t.decimal "prospect_amount", precision: 10, default: "0", null: false, comment: "案件想定金額"
    t.date "prospect_order_date", comment: "注文予定日"
    t.date "prospect_earning_date", comment: "売上予定日"
    t.string "distribute", default: "", null: false, comment: "商流"
    t.bigint "user_profile_id", comment: "担当者ID"
    t.bigint "company_information_id", comment: "企業情報ID"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description", default: "", null: false, comment: "説明文"
    t.index ["company_information_id"], name: "index_prospects_on_company_information_id"
    t.index ["customer_id"], name: "index_prospects_on_customer_id"
    t.index ["user_profile_id"], name: "index_prospects_on_user_profile_id"
  end

  create_table "sales_reports", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "営業報告" do |t|
    t.bigint "company_information_id", comment: "企業情報ID"
    t.bigint "customer_id", comment: "顧客ID"
    t.bigint "user_profile_id", comment: "ユーザ情報ID"
    t.date "occur_date", comment: "活動日"
    t.string "description", default: "", null: false, comment: "報告内容"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_information_id"], name: "index_sales_reports_on_company_information_id"
    t.index ["customer_id"], name: "index_sales_reports_on_customer_id"
    t.index ["user_profile_id"], name: "index_sales_reports_on_user_profile_id"
  end

  create_table "user_profiles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "ユーザ" do |t|
    t.string "name", default: "", null: false, comment: "ユーザ名"
    t.bigint "user_id", comment: "ユーザID"
    t.bigint "company_information_id", comment: "企業情報ID"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_information_id"], name: "index_user_profiles_on_company_information_id"
    t.index ["user_id"], name: "index_user_profiles_on_user_id"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "ユーザアカウント" do |t|
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
    t.datetime "disabled_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "customers", "company_informations"
  add_foreign_key "estimate_details", "estimates"
  add_foreign_key "estimate_details", "products"
  add_foreign_key "estimates", "company_informations"
  add_foreign_key "estimates", "customers"
  add_foreign_key "estimates", "prospects"
  add_foreign_key "estimates", "user_profiles"
  add_foreign_key "products", "company_informations"
  add_foreign_key "prospects", "company_informations"
  add_foreign_key "prospects", "customers"
  add_foreign_key "prospects", "user_profiles"
  add_foreign_key "sales_reports", "company_informations"
  add_foreign_key "sales_reports", "customers"
  add_foreign_key "sales_reports", "user_profiles"
  add_foreign_key "user_profiles", "company_informations"
  add_foreign_key "user_profiles", "users"
end
