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

ActiveRecord::Schema.define(version: 2021_12_12_055037) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "followers", force: :cascade do |t|
    t.string "twitterid"
    t.string "handle"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["handle"], name: "index_followers_on_handle", unique: true
    t.index ["twitterid"], name: "index_followers_on_twitterid", unique: true
  end

  create_table "followers_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "follower_id", null: false
    t.index ["follower_id"], name: "index_followers_users_on_follower_id"
    t.index ["user_id"], name: "index_followers_users_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "handle"
    t.string "twitterid"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["handle"], name: "index_users_on_handle", unique: true
    t.index ["twitterid"], name: "index_users_on_twitterid", unique: true
  end

end
