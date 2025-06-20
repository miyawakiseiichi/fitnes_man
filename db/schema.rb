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

ActiveRecord::Schema[7.2].define(version: 2025_05_29_001326) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contacts", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "frequencies", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "gyms", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "plans", force: :cascade do |t|
    t.bigint "user_id"
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", default: "", null: false
    t.index ["user_id"], name: "index_plans_on_user_id"
  end

  create_table "proteins", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "brand"
    t.integer "price"
    t.float "protein_content"
    t.integer "weight"
    t.string "flavor"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "supplements", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "brand"
    t.integer "price"
    t.string "category"
    t.string "effects"
    t.string "dosage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "reps"
    t.integer "sets"
    t.boolean "custom"
    t.boolean "completed"
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", default: ""
    t.string "username"
    t.integer "frequency_id", default: 4, null: false
    t.string "plan_type"
    t.integer "plan_id"
    t.string "uid"
    t.string "provider"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "weekly_menus", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "plan_id"
    t.date "scheduled_date"
    t.bigint "frequency_id", null: false
    t.index ["frequency_id"], name: "index_weekly_menus_on_frequency_id"
  end

  add_foreign_key "plans", "users"
  add_foreign_key "tasks", "users"
  add_foreign_key "weekly_menus", "frequencies"
end
