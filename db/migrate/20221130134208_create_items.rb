# frozen_string_literal: true

class CreateItems < ActiveRecord::Migration[6.1]
  def change
    create_table :items do |t|
      t.string :name, null: false
      t.decimal :price, null: false, precision: 10, scale: 2
      t.integer :count, null: false, default: 0
      t.belongs_to :shop, null: false, foreign_key: true

      t.timestamps
    end
  end
end
