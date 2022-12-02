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

ActiveRecord::Schema.define(version: 20_221_201_133_229) do
  create_table 'inventories', force: :cascade do |t|
    t.string 'name', null: false
    t.decimal 'cost', precision: 10, scale: 2, null: false
    t.integer 'user_id', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['user_id'], name: 'index_inventories_on_user_id'
  end

  create_table 'items', force: :cascade do |t|
    t.string 'name', null: false
    t.decimal 'price', precision: 10, scale: 2, null: false
    t.integer 'count', default: 0, null: false
    t.integer 'shop_id', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['shop_id'], name: 'index_items_on_shop_id'
  end

  create_table 'shops', force: :cascade do |t|
    t.string 'name', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'trades', force: :cascade do |t|
    t.integer 'initiator_id', null: false
    t.integer 'receiver_id', null: false
    t.string 'status', default: 'created', null: false
    t.integer 'user_id', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['user_id'], name: 'index_trades_on_user_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'email', null: false
    t.decimal 'balance', precision: 10, scale: 2, default: '0.0', null: false
    t.string 'password_digest'
    t.string 'token', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  add_foreign_key 'inventories', 'users'
  add_foreign_key 'items', 'shops'
  add_foreign_key 'trades', 'users'
end
