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

ActiveRecord::Schema.define(version: 2019_01_28_021757) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activity_items", id: :serial, force: :cascade do |t|
    t.integer "need_id"
    t.integer "user_id"
    t.string "item_type"
    t.json "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "evidence_items", force: :cascade do |t|
    t.bigint "evidence_type_id", null: false
    t.bigint "need_id", null: false
    t.text "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["evidence_type_id"], name: "index_evidence_items_on_evidence_type_id"
    t.index ["need_id"], name: "index_evidence_items_on_need_id"
  end

  create_table "evidence_types", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "kind", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "need_performance_points", id: :serial, force: :cascade do |t|
    t.integer "need_response_id", null: false
    t.date "date", null: false
    t.string "metric_type", null: false
    t.decimal "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["need_response_id"], name: "index_need_performance_points_on_need_response_id"
  end

  create_table "need_responses", id: :serial, force: :cascade do |t|
    t.integer "need_id", null: false
    t.string "response_type", null: false
    t.string "name", null: false
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["need_id"], name: "index_need_responses_on_need_id"
  end

  create_table "needs", id: :serial, force: :cascade do |t|
    t.string "role", null: false
    t.string "goal", null: false
    t.string "benefit", null: false
    t.text "met_when", default: [], array: true
    t.string "other_evidence"
    t.string "legislation"
    t.integer "canonical_need_id"
    t.integer "yearly_user_contacts"
    t.integer "yearly_site_views"
    t.integer "yearly_need_views"
    t.integer "yearly_searches"
  end

  create_table "needs_proposition_statements", id: false, force: :cascade do |t|
    t.integer "need_id", null: false
    t.integer "proposition_statement_id", null: false
    t.index ["need_id", "proposition_statement_id"], name: "index_need_statements"
    t.index ["proposition_statement_id", "need_id"], name: "index_statement_needs"
  end

  create_table "proposition_statements", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tag_types", id: :serial, force: :cascade do |t|
    t.string "identifier", null: false
    t.string "name", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id", null: false
    t.integer "need_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.integer "tag_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.text "roles", default: [], array: true
    t.text "bookmarks", default: [], array: true
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "authentication_token", limit: 30
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "evidence_items", "evidence_types"
  add_foreign_key "evidence_items", "needs"
end
