# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_08_15_144435) do
  create_table "cities", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clients", force: :cascade do |t|
    t.string "identification"
    t.string "identification_type"
    t.string "full_name"
    t.date "identification_issued_at"
    t.date "birth_date"
    t.string "sex"
    t.string "address"
    t.string "mobile_phone"
    t.string "landline_phone"
    t.string "billing_address"
    t.string "occupation"
    t.string "workplace"
    t.decimal "income"
    t.string "reference1_name"
    t.string "reference1_identification"
    t.string "reference1_address"
    t.string "reference1_phone"
    t.string "reference2_name"
    t.string "reference2_identification"
    t.string "reference2_address"
    t.string "reference2_phone"
    t.string "email"
    t.decimal "latitude"
    t.decimal "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "collection_id", null: false
    t.index ["collection_id"], name: "index_clients_on_collection_id"
  end

  create_table "collection_users", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "collection_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["collection_id"], name: "index_collection_users_on_collection_id"
    t.index ["user_id"], name: "index_collection_users_on_user_id"
  end

  create_table "collections", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "plate"
    t.string "phone"
    t.string "email"
    t.string "city"
    t.decimal "min_value"
    t.decimal "max_value"
    t.integer "payment_method"
    t.integer "payment_term_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["payment_term_id"], name: "index_collections_on_payment_term_id"
  end

  create_table "expense_types", force: :cascade do |t|
    t.string "name"
    t.decimal "max_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "expenses", force: :cascade do |t|
    t.integer "expense_type_id", null: false
    t.decimal "amount"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true, null: false
    t.index ["expense_type_id"], name: "index_expenses_on_expense_type_id"
    t.index ["user_id"], name: "index_expenses_on_user_id"
  end

  create_table "loans", force: :cascade do |t|
    t.integer "payment_term_id", null: false
    t.integer "client_id", null: false
    t.integer "installment_days"
    t.decimal "amount"
    t.text "details"
    t.decimal "insurance_amount"
    t.boolean "insurance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.index ["client_id"], name: "index_loans_on_client_id"
    t.index ["payment_term_id"], name: "index_loans_on_payment_term_id"
  end

  create_table "payment_terms", force: :cascade do |t|
    t.integer "percentage"
    t.integer "quota_days"
    t.string "payment_frequency"
    t.integer "payment_days"
    t.boolean "monthly"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payments", force: :cascade do |t|
    t.integer "client_id", null: false
    t.integer "loan_id", null: false
    t.integer "user_id", null: false
    t.decimal "amount"
    t.decimal "latitude"
    t.decimal "longitude"
    t.date "paid_at"
    t.text "details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_payments_on_client_id"
    t.index ["loan_id"], name: "index_payments_on_loan_id"
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "permission_roles", force: :cascade do |t|
    t.integer "role_id", null: false
    t.integer "section_id", null: false
    t.boolean "can_view"
    t.boolean "can_create"
    t.boolean "can_edit"
    t.boolean "can_destroy"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_permission_roles_on_role_id"
    t.index ["section_id"], name: "index_permission_roles_on_section_id"
  end

  create_table "permissions", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reasons", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "section_permissions", force: :cascade do |t|
    t.integer "section_id", null: false
    t.integer "permission_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["permission_id"], name: "index_section_permissions_on_permission_id"
    t.index ["section_id"], name: "index_section_permissions_on_section_id"
  end

  create_table "sections", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "statuses", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "third_party_types", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tracks", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "crypted_password"
    t.string "persistence_token"
    t.string "password_salt"
    t.string "single_access_token"
    t.string "perishable_token"
    t.integer "login_count", default: 0, null: false
    t.integer "failed_login_count", default: 0, null: false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string "current_login_ip"
    t.string "last_login_ip"
    t.string "salt"
    t.string "full_name"
    t.string "national_id"
    t.string "phone"
    t.string "address"
    t.integer "status_id", null: false
    t.integer "role_id", null: false
    t.string "reason_block"
    t.integer "city_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "parent_id"
    t.integer "hierarchy_level", default: 0, null: false
    t.string "api_token"
    t.index ["city_id"], name: "index_users_on_city_id"
    t.index ["parent_id"], name: "index_users_on_parent_id"
    t.index ["role_id"], name: "index_users_on_role_id"
    t.index ["status_id"], name: "index_users_on_status_id"
  end

  add_foreign_key "clients", "collections"
  add_foreign_key "collection_users", "collections"
  add_foreign_key "collection_users", "users"
  add_foreign_key "collections", "payment_terms"
  add_foreign_key "expenses", "expense_types"
  add_foreign_key "expenses", "users"
  add_foreign_key "loans", "clients"
  add_foreign_key "loans", "payment_terms"
  add_foreign_key "payments", "clients"
  add_foreign_key "payments", "loans"
  add_foreign_key "payments", "users"
  add_foreign_key "permission_roles", "roles"
  add_foreign_key "permission_roles", "sections"
  add_foreign_key "section_permissions", "permissions"
  add_foreign_key "section_permissions", "sections"
  add_foreign_key "users", "cities"
  add_foreign_key "users", "roles"
  add_foreign_key "users", "statuses"
end
