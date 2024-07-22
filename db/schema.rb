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

ActiveRecord::Schema[7.1].define(version: 2024_07_22_105115) do
  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "addresses", force: :cascade do |t|
    t.string "public_place"
    t.string "number"
    t.string "neighborhood"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "announcements", force: :cascade do |t|
    t.string "title"
    t.integer "manager_id", null: false
    t.integer "condo_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["condo_id"], name: "index_announcements_on_condo_id"
    t.index ["manager_id"], name: "index_announcements_on_manager_id"
  end

  create_table "common_areas", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "max_occupancy"
    t.text "rules"
    t.integer "condo_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["condo_id"], name: "index_common_areas_on_condo_id"
  end

  create_table "condo_managers", force: :cascade do |t|
    t.integer "manager_id", null: false
    t.integer "condo_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["condo_id"], name: "index_condo_managers_on_condo_id"
    t.index ["manager_id", "condo_id"], name: "index_condo_managers_on_manager_id_and_condo_id", unique: true
    t.index ["manager_id"], name: "index_condo_managers_on_manager_id"
  end

  create_table "condos", force: :cascade do |t|
    t.string "name"
    t.string "registration_number"
    t.integer "address_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address_id"], name: "index_condos_on_address_id"
    t.index ["registration_number"], name: "index_condos_on_registration_number", unique: true
  end

  create_table "floors", force: :cascade do |t|
    t.integer "tower_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tower_id"], name: "index_floors_on_tower_id"
  end

  create_table "managers", force: :cascade do |t|
    t.string "full_name"
    t.string "registration_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.boolean "is_super", default: false
    t.index ["email"], name: "index_managers_on_email", unique: true
    t.index ["registration_number"], name: "index_managers_on_registration_number", unique: true
    t.index ["reset_password_token"], name: "index_managers_on_reset_password_token", unique: true
  end

  create_table "reservations", force: :cascade do |t|
    t.date "date", null: false
    t.integer "status", default: 0, null: false
    t.integer "common_area_id", null: false
    t.integer "resident_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "single_charge_id"
    t.index ["common_area_id"], name: "index_reservations_on_common_area_id"
    t.index ["resident_id"], name: "index_reservations_on_resident_id"
  end

  create_table "residents", force: :cascade do |t|
    t.string "full_name"
    t.string "registration_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "status", default: 0
    t.index ["email"], name: "index_residents_on_email", unique: true
    t.index ["registration_number"], name: "index_residents_on_registration_number", unique: true
    t.index ["reset_password_token"], name: "index_residents_on_reset_password_token", unique: true
  end

  create_table "superintendents", force: :cascade do |t|
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "condo_id", null: false
    t.integer "tenant_id", null: false
    t.index ["condo_id"], name: "index_superintendents_on_condo_id"
    t.index ["tenant_id"], name: "index_superintendents_on_tenant_id"
  end

  create_table "towers", force: :cascade do |t|
    t.integer "floor_quantity"
    t.string "name"
    t.integer "condo_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "units_per_floor"
    t.integer "status", default: 0, null: false
    t.index ["condo_id"], name: "index_towers_on_condo_id"
  end

  create_table "unit_types", force: :cascade do |t|
    t.text "description"
    t.decimal "metreage", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "fraction", precision: 10, scale: 5
    t.integer "condo_id", null: false
    t.index ["condo_id"], name: "index_unit_types_on_condo_id"
  end

  create_table "units", force: :cascade do |t|
    t.integer "unit_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "floor_id", null: false
    t.integer "tenant_id"
    t.integer "owner_id"
    t.index ["floor_id"], name: "index_units_on_floor_id"
    t.index ["owner_id"], name: "index_units_on_owner_id"
    t.index ["tenant_id"], name: "index_units_on_tenant_id"
    t.index ["unit_type_id"], name: "index_units_on_unit_type_id"
  end

  create_table "visitor_entries", force: :cascade do |t|
    t.integer "condo_id", null: false
    t.string "full_name"
    t.string "identity_number"
    t.integer "unit_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "database_datetime", null: false
    t.index ["condo_id"], name: "index_visitor_entries_on_condo_id"
    t.index ["unit_id"], name: "index_visitor_entries_on_unit_id"
  end

  create_table "visitors", force: :cascade do |t|
    t.string "full_name"
    t.string "identity_number"
    t.integer "category"
    t.date "visit_date"
    t.integer "recurrence"
    t.integer "resident_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "condo_id", null: false
    t.integer "status", default: 0
    t.index ["condo_id"], name: "index_visitors_on_condo_id"
    t.index ["resident_id"], name: "index_visitors_on_resident_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "announcements", "condos"
  add_foreign_key "announcements", "managers"
  add_foreign_key "common_areas", "condos"
  add_foreign_key "condo_managers", "condos"
  add_foreign_key "condo_managers", "managers"
  add_foreign_key "condos", "addresses"
  add_foreign_key "floors", "towers"
  add_foreign_key "reservations", "common_areas"
  add_foreign_key "reservations", "residents"
  add_foreign_key "superintendents", "condos"
  add_foreign_key "superintendents", "residents", column: "tenant_id"
  add_foreign_key "towers", "condos"
  add_foreign_key "unit_types", "condos"
  add_foreign_key "units", "floors"
  add_foreign_key "units", "residents", column: "owner_id"
  add_foreign_key "units", "residents", column: "tenant_id"
  add_foreign_key "units", "unit_types"
  add_foreign_key "visitor_entries", "condos"
  add_foreign_key "visitor_entries", "units"
  add_foreign_key "visitors", "condos"
  add_foreign_key "visitors", "residents"
end
