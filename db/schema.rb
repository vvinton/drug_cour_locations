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

ActiveRecord::Schema.define(version: 20180329142503) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "coordinator_informations", id: :serial, force: :cascade do |t|
    t.integer "program_information_id"
    t.string "current_contact"
    t.string "title"
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["program_information_id"], name: "index_coordinator_informations_on_program_information_id"
  end



  create_table "geo_data", id: :serial, force: :cascade do |t|
    t.jsonb "data"
    t.float "lat"
    t.float "lng"
    t.string "marker"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "grant_informations", id: :serial, force: :cascade do |t|
    t.integer "program_information_id"
    t.string "agency"
    t.string "grant_number"
    t.integer "grant_year"
    t.string "grant_type"
    t.string "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["program_information_id"], name: "index_grant_informations_on_program_information_id"
  end

  create_table "imports", id: :serial, force: :cascade do |t|
    t.string "mdb_file_name"
    t.string "mdb_content_type"
    t.integer "mdb_file_size"
    t.datetime "mdb_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "judge_informaions", id: :serial, force: :cascade do |t|
    t.integer "program_information_id"
    t.string "last_name"
    t.string "firt_name"
    t.string "email"
    t.string "title"
    t.string "phone"
    t.string "current_contact"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["program_information_id"], name: "index_judge_informaions_on_program_information_id"
  end

  create_table "jurisdiction_informations", id: :serial, force: :cascade do |t|
    t.integer "program_information_id"
    t.string "jurisdiction_type"
    t.string "square_mileage"
    t.string "population"
    t.string "population_data_year"
    t.string "rural_status"
    t.string "rural_status_label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["program_information_id"], name: "index_jurisdiction_informations_on_program_information_id"
  end

  create_table "jurisdiction_names", id: :serial, force: :cascade do |t|
    t.integer "jurisdiction_information_id"
    t.string "jurisdiction_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["jurisdiction_information_id"], name: "index_jurisdiction_names_on_jurisdiction_information_id"
  end

  create_table "program_informations", id: :serial, force: :cascade do |t|
    t.string "program_name"
    t.string "court_name"
    t.string "operational_status"
    t.string "case_type"
    t.string "implementation_date"
    t.string "program_type"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "zip_code"
    t.string "phone_number"
    t.string "email"
    t.string "website"
    t.string "notes"
    t.string "program_add_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "lat"
    t.float "long"
    t.jsonb "geodata"
    t.string "county"
  end

  create_table "roles", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_roles_on_user_id"
  end

  create_table "search_item_locations", id: :serial, force: :cascade do |t|
    t.integer "search_item_id"
    t.integer "program_information_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "search_items", id: :serial, force: :cascade do |t|
    t.float "lat"
    t.float "lng"
    t.string "short_name"
    t.string "hint"
    t.string "full_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "state_coordinators", id: :serial, force: :cascade do |t|
    t.string "current_contact"
    t.string "last_name"
    t.string "first_name"
    t.string "email"
    t.string "title"
    t.string "phone"
    t.string "address"
    t.string "agency"
    t.string "zip"
    t.string "website"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "state"
    t.string "city"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "zipdbs", id: :serial, force: :cascade do |t|
    t.integer "zip"
    t.float "lng"
    t.float "lat"
    t.string "city"
    t.string "state"
    t.string "county"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
