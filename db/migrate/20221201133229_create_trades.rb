# frozen_string_literal: true

class CreateTrades < ActiveRecord::Migration[6.1]
  def change
    create_table :trades do |t|
      t.integer :buyer_id, null: false
      t.integer :seller_id, null: false
      t.integer :seller_inventory_id, null: false
      t.decimal :offered_price, null: false, precision: 10, scale: 2
      t.integer :status, null: false, default: 1

      t.timestamps
    end

    add_index :trades, :buyer_id
    add_index :trades, :seller_id
  end
end
