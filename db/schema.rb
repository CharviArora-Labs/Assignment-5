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

ActiveRecord::Schema[8.1].define(version: 2026_02_18_070910) do
  create_table "appointments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "patient_id", null: false
    t.integer "provider_id", null: false
    t.datetime "scheduled_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id", "scheduled_at"], name: "index_appointments_on_patient_id_and_scheduled_at"
    t.index ["patient_id"], name: "index_appointments_on_patient_id"
    t.index ["provider_id"], name: "index_appointments_on_provider_id"
    t.index ["scheduled_at"], name: "index_appointments_on_scheduled_at"
  end

  create_table "patients", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_patients_on_email", unique: true
  end

  create_table "providers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.string "specialization", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "appointments", "patients"
  add_foreign_key "appointments", "providers"
end
