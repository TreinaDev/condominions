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

ActiveRecord::Schema[7.1].define(version: 2024_06_25_222041) do
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

  create_table "common_areas", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "max_occupancy"
    t.text "rules"
    t.integer "condominium_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["condominium_id"], name: "index_common_areas_on_condominium_id"
  end

  create_table "condos", force: :cascade do |t|
    t.string "name"
    t.string "registration_number"
    t.integer "address_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address_id"], name: "index_condos_on_address_id"
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
  end

  create_table "residents", force: :cascade do |t|
    t.string "full_name"
    t.string "registration_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "towers", force: :cascade do |t|
    t.integer "floor_quantity"
    t.string "name"
    t.integer "condo_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "units_per_floor"
    t.index ["condo_id"], name: "index_towers_on_condo_id"
  end

  create_table "unit_types", force: :cascade do |t|
    t.text "description"
    t.decimal "metreage", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "units", force: :cascade do |t|
    t.integer "unit_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "floor_id", null: false
    t.index ["floor_id"], name: "index_units_on_floor_id"
    t.index ["unit_type_id"], name: "index_units_on_unit_type_id"
  end

  add_foreign_key "common_areas", "condos", column: "condominium_id"
  add_foreign_key "condos", "addresses"
  add_foreign_key "floors", "towers"
  add_foreign_key "towers", "condos"
  add_foreign_key "units", "floors"
  add_foreign_key "units", "unit_types"
end
