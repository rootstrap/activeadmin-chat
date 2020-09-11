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

ActiveRecord::Schema.define(version: 2018_12_27_144938) do

  create_table "admin_users", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "api_multi_people", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "api_people", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "conversations", force: :cascade do |t|
    t.integer "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_conversations_on_person_id"
  end

  create_table "multi_conversations", force: :cascade do |t|
    t.integer "multi_person_id"
    t.integer "admin_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_user_id"], name: "index_multi_conversations_on_admin_user_id"
    t.index ["multi_person_id"], name: "index_multi_conversations_on_multi_person_id"
  end

  create_table "multi_texts", force: :cascade do |t|
    t.string "content"
    t.string "sender_type"
    t.integer "sender_id"
    t.integer "multi_conversation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["multi_conversation_id"], name: "index_multi_texts_on_multi_conversation_id"
    t.index ["sender_type", "sender_id"], name: "index_multi_texts_on_sender_type_and_sender_id"
  end

  create_table "texts", force: :cascade do |t|
    t.string "content"
    t.string "sender_type"
    t.integer "sender_id"
    t.integer "conversation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conversation_id"], name: "index_texts_on_conversation_id"
    t.index ["sender_type", "sender_id"], name: "index_texts_on_sender_type_and_sender_id"
  end

end
