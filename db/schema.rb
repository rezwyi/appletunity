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

ActiveRecord::Schema.define(version: 20140228092337) do

  create_table "admins", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "cities", force: true do |t|
    t.string  "name",       null: false
    t.integer "regions_id"
  end

  create_table "logoables", force: true do |t|
    t.integer "resource_id"
    t.string  "resource_type"
    t.integer "logo_id"
  end

  add_index "logoables", ["resource_id", "resource_type", "logo_id"], name: "index_logoables_on_resource_id_and_resource_type_and_logo_id", unique: true, using: :btree

  create_table "logos", force: true do |t|
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "image_fingerprint"
    t.boolean  "force",              default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "logos", ["image_fingerprint"], name: "index_logos_on_image_fingerprint", using: :btree

  create_table "occupationables", force: true do |t|
    t.integer "vacancy_id"
    t.integer "occupation_id"
  end

  create_table "occupations", force: true do |t|
    t.string "name", null: false
  end

  add_index "occupations", ["name"], name: "index_occupations_on_name", unique: true, using: :btree

  create_table "regions", force: true do |t|
    t.string "name", null: false
  end

  create_table "vacancies", force: true do |t|
    t.string   "title",                                    null: false
    t.text     "body",                                     null: false
    t.string   "contact_email",                            null: false
    t.string   "contact_phone"
    t.boolean  "agreed_to_offer",                          null: false
    t.datetime "expired_at"
    t.string   "edit_token",                               null: false
    t.string   "location"
    t.string   "company_name",                             null: false
    t.string   "company_website"
    t.string   "inline_logo_file_name"
    t.string   "inline_logo_content_type"
    t.integer  "inline_logo_file_size"
    t.datetime "inline_logo_updated_at"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.text     "rendered_body",                            null: false
    t.boolean  "approved",                 default: false, null: false
  end

  add_index "vacancies", ["edit_token"], name: "index_vacancies_on_edit_token", unique: true, using: :btree

  create_table "vacancies_cities", force: true do |t|
    t.integer "vacancies_id"
    t.integer "cities_id"
  end

  create_table "vacancies_companies", force: true do |t|
    t.integer "companies_id"
    t.integer "vacancies_id"
  end

end
