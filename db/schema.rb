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

ActiveRecord::Schema.define(version: 20160529102512) do

  create_table "articles", force: true do |t|
    t.string   "name",                     null: false
    t.integer  "provider_id",              null: false
    t.datetime "provided_at"
    t.text     "description"
    t.float    "price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cover_image_file_name"
    t.string   "cover_image_content_type"
    t.integer  "cover_image_file_size"
    t.datetime "cover_image_updated_at"
  end

  add_index "articles", ["provider_id"], name: "fk_articles_publishers", using: :btree

  create_table "articles_designers", force: true do |t|
    t.integer  "designer_id", null: false
    t.integer  "article_id",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "articles_designers", ["article_id"], name: "fk_articles_designers_articles", using: :btree
  add_index "articles_designers", ["designer_id"], name: "fk_articles_designers_designers", using: :btree

  create_table "cart_items", force: true do |t|
    t.integer  "article_id"
    t.integer  "cart_id"
    t.float    "price"
    t.integer  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "carts", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "designers", force: true do |t|
    t.string   "name"
    t.integer  "telephone"
    t.string   "enterprise"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forum_posts", force: true do |t|
    t.string   "name",       limit: 50,             null: false
    t.string   "subject",                           null: false
    t.text     "body"
    t.integer  "root_id",               default: 0, null: false
    t.integer  "parent_id",             default: 0, null: false
    t.integer  "depth",                 default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "order_items", force: true do |t|
    t.integer  "article_id"
    t.integer  "order_id"
    t.float    "price"
    t.integer  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "order_items", ["order_id"], name: "fk_order_items_orders", using: :btree

  create_table "orders", force: true do |t|
    t.string   "email"
    t.string   "phone_number"
    t.string   "ship_to_first_name"
    t.string   "ship_to_last_name"
    t.string   "ship_to_address"
    t.string   "ship_to_city"
    t.string   "ship_to_postal_code"
    t.string   "ship_to_country_code"
    t.string   "customer_ip"
    t.string   "status"
    t.string   "error_message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "providers", force: true do |t|
    t.string   "name"
    t.integer  "telephone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: true do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "name",                               null: false
    t.string   "login",                              null: false
    t.string   "email",                              null: false
    t.string   "crypted_password",                   null: false
    t.string   "password_salt",                      null: false
    t.string   "persistence_token",                  null: false
    t.string   "perishable_token",                   null: false
    t.integer  "login_count",            default: 0, null: false
    t.integer  "failed_login_count",     default: 0, null: false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
  end

end
