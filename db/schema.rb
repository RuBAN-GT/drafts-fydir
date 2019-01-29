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

ActiveRecord::Schema.define(version: 20160702220020) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "conversation_members", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "conversation_id"
    t.boolean  "parted",          default: true, null: false
    t.boolean  "viewed",          default: true, null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.index ["conversation_id"], name: "index_conversation_members_on_conversation_id", using: :btree
    t.index ["user_id"], name: "index_conversation_members_on_user_id", using: :btree
  end

  create_table "conversations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "looking_activities", force: :cascade do |t|
    t.string   "slug",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "looking_requests", force: :cascade do |t|
    t.text     "description"
    t.string   "looking_type",        default: "group", null: false
    t.boolean  "microphone",          default: false,   null: false
    t.integer  "min_light"
    t.string   "experience",          default: "every", null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "user_id"
    t.integer  "platform_id"
    t.integer  "looking_activity_id"
    t.index ["looking_activity_id"], name: "index_looking_requests_on_looking_activity_id", using: :btree
    t.index ["platform_id"], name: "index_looking_requests_on_platform_id", using: :btree
    t.index ["user_id"], name: "index_looking_requests_on_user_id", using: :btree
  end

  create_table "messages", force: :cascade do |t|
    t.text     "body",            null: false
    t.integer  "user_id"
    t.integer  "conversation_id", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["conversation_id"], name: "index_messages_on_conversation_id", using: :btree
    t.index ["user_id"], name: "index_messages_on_user_id", using: :btree
  end

  create_table "platforms", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "slug",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string   "slug",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                                  default: "", null: false
    t.string   "encrypted_password",                     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "failed_attempts",                        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.string   "authentication_token",        limit: 30
    t.string   "realname"
    t.string   "nickname",                                            null: false
    t.string   "motto"
    t.text     "about"
    t.datetime "last_active_at"
    t.integer  "platform_id"
    t.string   "guardian_name"
    t.string   "guardian_token"
    t.datetime "guardian_token_confirmed_at"
    t.datetime "guardian_updated_at"
    t.string   "vkontakte"
    t.string   "facebook"
    t.string   "twitter"
    t.string   "twitch"
    t.string   "telegram"
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree
  end

  create_table "users_ratios", force: :cascade do |t|
    t.integer  "point"
    t.integer  "user_id"
    t.integer  "voted_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_users_ratios_on_user_id", using: :btree
    t.index ["voted_id"], name: "index_users_ratios_on_voted_id", using: :btree
  end

  create_table "users_roles", primary_key: ["user_id", "role_id"], force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "role_id", null: false
    t.index ["role_id"], name: "index_users_roles_on_role_id", using: :btree
    t.index ["user_id"], name: "index_users_roles_on_user_id", using: :btree
  end

end
