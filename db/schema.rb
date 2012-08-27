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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120827060351) do

  create_table "cities", :force => true do |t|
    t.string  "name",       :null => false
    t.integer "regions_id"
  end

  create_table "companies", :force => true do |t|
    t.string "name",     :null => false
    t.string "site_url"
  end

  create_table "occupations", :force => true do |t|
    t.string "name", :null => false
  end

  create_table "regions", :force => true do |t|
    t.string "name", :null => false
  end

  create_table "vacancies", :force => true do |t|
    t.string  "title",           :null => false
    t.text    "description",     :null => false
    t.string  "contact_email",   :null => false
    t.string  "contact_phone"
    t.boolean "agreed_to_offer", :null => false
    t.date    "expired_at",      :null => false
    t.string  "edit_token",      :null => false
  end

  create_table "vacancies_cities", :force => true do |t|
    t.integer "vacancies_id"
    t.integer "cities_id"
  end

  create_table "vacancies_companies", :force => true do |t|
    t.integer "companies_id"
    t.integer "vacancies_id"
  end

  create_table "vacancies_occupations", :force => true do |t|
    t.integer "vacancies_id"
    t.integer "occupations_id"
  end

end
