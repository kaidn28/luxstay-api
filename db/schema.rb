# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_12_11_170844) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookings", force: :cascade do |t|
    t.datetime "start_date"
    t.datetime "end_date"
    t.bigint "user_id", null: false
    t.bigint "place_id", null: false
    t.integer "status"
    t.integer "payment_gateway"
    t.integer "num_of_people"
    t.float "price"
    t.string "coupon_code"
    t.index ["place_id"], name: "index_bookings_on_place_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "coupons", force: :cascade do |t|
    t.string "code_name"
    t.datetime "start_date"
    t.datetime "expire_date"
    t.float "discount"
  end

  create_table "facilities", force: :cascade do |t|
    t.string "name"
  end

  create_table "favorites", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "place_id", null: false
    t.index ["place_id"], name: "index_favorites_on_place_id"
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "history_bookings", force: :cascade do |t|
    t.datetime "modify_datetime"
    t.bigint "booking_id", null: false
    t.integer "status"
    t.index ["booking_id"], name: "index_history_bookings_on_booking_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.text "content"
    t.boolean "viewed"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "overviews", force: :cascade do |t|
    t.string "image"
    t.bigint "place_id", null: false
    t.index ["place_id"], name: "index_overviews_on_place_id"
  end

  create_table "place_facilities", force: :cascade do |t|
    t.bigint "place_id", null: false
    t.bigint "facility_id", null: false
    t.index ["facility_id"], name: "index_place_facilities_on_facility_id"
    t.index ["place_id"], name: "index_place_facilities_on_place_id"
  end

  create_table "places", force: :cascade do |t|
    t.string "name"
    t.string "details"
    t.bigint "user_id", null: false
    t.integer "city"
    t.integer "place_type"
    t.text "address"
    t.boolean "accepted"
    t.string "image"
    t.index ["user_id"], name: "index_places_on_user_id"
  end

  create_table "policies", force: :cascade do |t|
    t.integer "currency"
    t.integer "max_num_of_people"
    t.bigint "place_id", null: false
    t.integer "cancel_policy"
    t.index ["place_id"], name: "index_policies_on_place_id"
  end

  create_table "ratings", force: :cascade do |t|
    t.integer "score"
    t.text "comment"
    t.bigint "user_id", null: false
    t.bigint "place_id", null: false
    t.index ["place_id"], name: "index_ratings_on_place_id"
    t.index ["user_id"], name: "index_ratings_on_user_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.integer "square"
    t.integer "num_of_bedroom"
    t.integer "num_of_bed"
    t.integer "num_of_bathroom"
    t.integer "num_of_kitchen"
    t.bigint "place_id", null: false
    t.index ["place_id"], name: "index_rooms_on_place_id"
  end

  create_table "rules", force: :cascade do |t|
    t.text "special_rules"
    t.bigint "place_id", null: false
    t.integer "smoking"
    t.integer "pet"
    t.integer "cooking"
    t.integer "party"
    t.index ["place_id"], name: "index_rules_on_place_id"
  end

  create_table "schedule_prices", force: :cascade do |t|
    t.float "normal_day_price"
    t.float "weekend_price"
    t.float "cleaning_price"
    t.bigint "place_id", null: false
    t.index ["place_id"], name: "index_schedule_prices_on_place_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "name"
    t.string "phone"
    t.datetime "birthday"
    t.string "avatar"
    t.string "password_digest"
    t.string "remember_digest"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "activation_digest"
    t.boolean "activated"
    t.datetime "activated_at"
    t.string "address"
    t.integer "gender"
    t.boolean "admin"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "bookings", "places"
  add_foreign_key "bookings", "users"
  add_foreign_key "favorites", "places"
  add_foreign_key "favorites", "users"
  add_foreign_key "history_bookings", "bookings"
  add_foreign_key "notifications", "users"
  add_foreign_key "overviews", "places"
  add_foreign_key "place_facilities", "facilities"
  add_foreign_key "place_facilities", "places"
  add_foreign_key "places", "users"
  add_foreign_key "policies", "places"
  add_foreign_key "ratings", "places"
  add_foreign_key "ratings", "users"
  add_foreign_key "rooms", "places"
  add_foreign_key "rules", "places"
  add_foreign_key "schedule_prices", "places"
end
