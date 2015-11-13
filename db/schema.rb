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

ActiveRecord::Schema.define(version: 20151112133846) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "approvals", force: :cascade do |t|
    t.integer "user_id"
    t.integer "edition_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text     "comment"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.string   "role",             default: "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id"], name: "index_comments_on_commentable_id", using: :btree
  add_index "comments", ["commentable_type"], name: "index_comments_on_commentable_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "content_owners", force: :cascade do |t|
    t.string "title", null: false
    t.string "href",  null: false
  end

  create_table "editions", force: :cascade do |t|
    t.integer  "guide_id"
    t.integer  "user_id"
    t.text     "title"
    t.text     "description"
    t.text     "body"
    t.string   "update_type"
    t.text     "phase",                    default: "alpha"
    t.text     "related_discussion_href"
    t.text     "related_discussion_title"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.text     "state"
    t.text     "change_note"
    t.integer  "content_owner_id",                           null: false
  end

  create_table "guides", force: :cascade do |t|
    t.string   "slug"
    t.string   "content_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "slug_migrations", force: :cascade do |t|
    t.string   "slug"
    t.boolean  "completed",  default: false, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "guide_id"
    t.string   "content_id",                 null: false
  end

  add_index "slug_migrations", ["slug"], name: "index_slug_migrations_on_slug", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.text     "uid"
    t.text     "name"
    t.text     "email"
    t.text     "organisation_slug"
    t.text     "organisation_content_id"
    t.boolean  "remotely_signed_out",     default: false
    t.boolean  "disabled",                default: false
    t.text     "permissions",                                          array: true
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["organisation_content_id"], name: "index_users_on_organisation_content_id", using: :btree
  add_index "users", ["uid"], name: "index_users_on_uid", using: :btree

end
