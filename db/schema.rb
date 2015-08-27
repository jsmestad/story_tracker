# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150827174339) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "follows", force: :cascade do |t|
    t.integer  "followable_id",                   null: false
    t.string   "followable_type",                 null: false
    t.integer  "follower_id",                     null: false
    t.string   "follower_type",                   null: false
    t.boolean  "blocked",         default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "follows", ["followable_id", "followable_type"], name: "fk_followables", using: :btree
  add_index "follows", ["follower_id", "follower_type"], name: "fk_follows", using: :btree

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "stories", force: :cascade do |t|
    t.integer  "user_id",                                     null: false
    t.string   "external_ref"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "subscribe",    default: true,                 null: false
    t.integer  "state",        default: 0,                    null: false
    t.string   "name"
    t.string   "after_id"
    t.text     "description"
    t.string   "story_type",   default: "feature",            null: false
    t.uuid     "guid",         default: "uuid_generate_v4()"
  end

  add_index "stories", ["guid"], name: "index_stories_on_guid", unique: true, using: :btree
  add_index "stories", ["story_type"], name: "is_defect", where: "((story_type)::text = 'defect'::text)", using: :btree
  add_index "stories", ["story_type"], name: "is_feature", where: "((story_type)::text = 'feature'::text)", using: :btree
  add_index "stories", ["user_id"], name: "index_stories_on_user_id", using: :btree

  create_table "story_callbacks", force: :cascade do |t|
    t.integer  "story_id",   null: false
    t.string   "highlight",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "story_callbacks", ["story_id"], name: "index_story_callbacks_on_story_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "provider",                                         null: false
    t.string   "uid",                                              null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_api_key"
    t.string   "email_address"
    t.integer  "role",              default: 0,                    null: false
    t.string   "username"
    t.uuid     "guid",              default: "uuid_generate_v4()"
    t.string   "token"
  end

  add_index "users", ["guid"], name: "index_users_on_guid", unique: true, using: :btree
  add_index "users", ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true, using: :btree
  add_index "users", ["token"], name: "index_users_on_token", using: :btree

end
