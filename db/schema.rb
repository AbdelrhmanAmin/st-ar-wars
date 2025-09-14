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

ActiveRecord::Schema.define(version: 2025_09_14_093825) do

  create_table "films", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "films_people", force: :cascade do |t|
    t.integer "film_id", null: false
    t.integer "person_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["film_id"], name: "index_films_people_on_film_id"
    t.index ["person_id"], name: "index_films_people_on_person_id"
  end

  create_table "people", force: :cascade do |t|
    t.string "name"
    t.integer "species_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "home_planet_id"
    t.index ["species_id"], name: "index_people_on_species_id"
  end

  create_table "person_films", force: :cascade do |t|
    t.integer "person_id", null: false
    t.integer "film_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["film_id"], name: "index_person_films_on_film_id"
    t.index ["person_id"], name: "index_person_films_on_person_id"
  end

  create_table "planets", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "senator_id"
  end

  create_table "social_media_event_attendees", force: :cascade do |t|
    t.integer "social_media_event_id", null: false
    t.integer "social_media_user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["social_media_event_id"], name: "index_social_media_event_attendees_on_social_media_event_id"
    t.index ["social_media_user_id"], name: "index_social_media_event_attendees_on_social_media_user_id"
  end

  create_table "social_media_events", force: :cascade do |t|
    t.string "title"
    t.date "date"
    t.integer "creator_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["creator_id"], name: "index_social_media_events_on_creator_id"
  end

  create_table "social_media_posts", force: :cascade do |t|
    t.integer "social_media_user_id", null: false
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["social_media_user_id"], name: "index_social_media_posts_on_social_media_user_id"
  end

  create_table "social_media_user_friendships", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "friend_id", null: false
    t.boolean "accepted", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["friend_id", "user_id"], name: "index_social_media_user_friendships_on_friend_id_and_user_id", unique: true
    t.index ["friend_id"], name: "index_social_media_user_friendships_on_friend_id"
    t.index ["user_id", "friend_id"], name: "index_social_media_user_friendships_on_user_id_and_friend_id", unique: true
    t.index ["user_id"], name: "index_social_media_user_friendships_on_user_id"
  end

  create_table "social_media_users", force: :cascade do |t|
    t.string "full_name"
    t.integer "age"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "species", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "films_people", "films"
  add_foreign_key "films_people", "people"
  add_foreign_key "people", "species"
  add_foreign_key "person_films", "films"
  add_foreign_key "person_films", "people"
  add_foreign_key "social_media_event_attendees", "social_media_events"
  add_foreign_key "social_media_event_attendees", "social_media_users"
  add_foreign_key "social_media_events", "social_media_users", column: "creator_id"
  add_foreign_key "social_media_posts", "social_media_users"
  add_foreign_key "social_media_user_friendships", "social_media_users", column: "friend_id"
  add_foreign_key "social_media_user_friendships", "social_media_users", column: "user_id"
end
