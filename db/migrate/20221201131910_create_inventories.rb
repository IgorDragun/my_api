# frozen_string_literal: true

class CreateInventories < ActiveRecord::Migration[6.1]
  def change
    create_table :inventories do |t|
      t.string :name, null: false
      t.decimal :cost, null: false, precision: 10, scale: 2
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :inventories, :name
  end
end
