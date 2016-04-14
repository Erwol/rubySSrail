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

ActiveRecord::Schema.define(version: 20160411103336) do

  create_table "articles", force: true do |t|
    t.string   "name",        null: false
    t.integer  "provider_id", null: false
    t.datetime "provided_at"
    t.text     "description"
    t.float    "price"
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "designers", force: true do |t|
    t.string   "name"
    t.integer  "telephone"
    t.string   "enterprise"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "providers", force: true do |t|
    t.string   "name"
    t.integer  "telephone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
