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

ActiveRecord::Schema.define(version: 20180220011151) do

  create_table "bids", force: :cascade do |t|
    t.integer "amount"
    t.integer "user_id"
    t.integer "draft_id"
    t.integer "player_id"
    t.boolean "winning", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["draft_id"], name: "index_bids_on_draft_id"
    t.index ["player_id"], name: "index_bids_on_player_id"
    t.index ["user_id"], name: "index_bids_on_user_id"
  end

  create_table "drafts", force: :cascade do |t|
    t.integer "year"
    t.string "format"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "open"
    t.integer "nominated_player_id"
    t.integer "nominating_user_id"
  end

  create_table "games", force: :cascade do |t|
    t.integer "season"
    t.integer "week"
    t.integer "player_id"
    t.string "esbid"
    t.string "gsisPlayerId"
    t.string "player_name"
    t.string "position"
    t.string "team"
    t.integer "passing_attempts"
    t.integer "passing_completions"
    t.integer "passing_yards"
    t.integer "passing_touchdowns"
    t.integer "interceptions_thrown"
    t.integer "rushing_attempts"
    t.integer "rushing_yards"
    t.integer "rushing_touchdowns"
    t.integer "receptions"
    t.integer "receiving_yards"
    t.integer "receiving_touchdowns"
    t.integer "return_yards"
    t.integer "return_touchdowns"
    t.integer "fumbles_recovered_for_touchdown"
    t.integer "fumbles_lost"
    t.integer "two_point_conversions"
    t.integer "pat_made"
    t.integer "pat_missed"
    t.integer "fg_made_0_19"
    t.integer "fg_made_20_29"
    t.integer "fg_made_30_39"
    t.integer "fg_made_40_49"
    t.integer "fg_made_50_plus"
    t.integer "fg_missed_0_19"
    t.integer "fg_missed_20_29"
    t.integer "fg_missed_30_39"
    t.integer "fg_missed_40_49"
    t.integer "fg_missed_50_plus"
    t.integer "sacks"
    t.integer "interceptions_caught"
    t.integer "fumbles_recovered"
    t.integer "safeties"
    t.integer "defensive_touchdowns"
    t.integer "blocked_kicks"
    t.integer "team_return_yards"
    t.integer "team_return_touchdowns"
    t.integer "points_allowed"
    t.integer "yards_allowed"
    t.integer "team_two_pt_return"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_games_on_player_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "esbid"
    t.string "gsisPlayerId"
    t.string "player_name"
    t.string "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "auctioneer", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
