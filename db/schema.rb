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

ActiveRecord::Schema.define(version: 20170411160502) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "coordinator_informations", force: :cascade do |t|
    t.integer  "program_information_id"
    t.string   "current_contact"
    t.string   "title"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["program_information_id"], name: "index_coordinator_informations_on_program_information_id", using: :btree
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  end

  create_table "geo_data", force: :cascade do |t|
    t.jsonb    "data"
    t.float    "lat"
    t.float    "lng"
    t.string   "marker"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "grant_informations", force: :cascade do |t|
    t.integer  "program_information_id"
    t.string   "agency"
    t.string   "grant_number"
    t.integer  "grant_year"
    t.string   "grant_type"
    t.string   "amount"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["program_information_id"], name: "index_grant_informations_on_program_information_id", using: :btree
  end

  create_table "imports", force: :cascade do |t|
    t.string   "mdb_file_name"
    t.string   "mdb_content_type"
    t.integer  "mdb_file_size"
    t.datetime "mdb_updated_at"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "judge_informaions", force: :cascade do |t|
    t.integer  "program_information_id"
    t.string   "last_name"
    t.string   "firt_name"
    t.string   "email"
    t.string   "title"
    t.string   "phone"
    t.string   "current_contact"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["program_information_id"], name: "index_judge_informaions_on_program_information_id", using: :btree
  end

  create_table "jurisdiction_informations", force: :cascade do |t|
    t.integer  "program_information_id"
    t.string   "jurisdiction_type"
    t.string   "square_mileage"
    t.string   "population"
    t.string   "population_data_year"
    t.string   "rural_status"
    t.string   "rural_status_label"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["program_information_id"], name: "index_jurisdiction_informations_on_program_information_id", using: :btree
  end

  create_table "jurisdiction_names", force: :cascade do |t|
    t.integer  "jurisdiction_information_id"
    t.string   "jurisdiction_name"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["jurisdiction_information_id"], name: "index_jurisdiction_names_on_jurisdiction_information_id", using: :btree
  end

  create_table "program_informations", force: :cascade do |t|
    t.string   "program_name"
    t.string   "court_name"
    t.string   "operational_status"
    t.string   "case_type"
    t.string   "implementation_date"
    t.string   "program_type"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.string   "phone_number"
    t.string   "email"
    t.string   "website"
    t.string   "notes"
    t.string   "program_add_date"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.float    "lat"
    t.float    "long"
    t.jsonb    "geodata"
    t.string   "county"
  end

  create_table "roles", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_roles_on_user_id", using: :btree
  end

  create_table "search_item_locations", force: :cascade do |t|
    t.integer  "search_item_id"
    t.integer  "program_information_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "search_items", force: :cascade do |t|
    t.float    "lat"
    t.float    "lng"
    t.string   "short_name"
    t.string   "hint"
    t.string   "full_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "state_coordinators", force: :cascade do |t|
    t.string   "current_contact"
    t.string   "last_name"
    t.string   "firt_name"
    t.string   "email"
    t.string   "title"
    t.string   "phone"
    t.string   "address"
    t.string   "agency"
    t.string   "zip"
    t.string   "website"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
