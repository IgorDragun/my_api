# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name, null: false, unique: true
      t.string :email, null: false, unique: true
      t.decimal :balance, null: false, precision: 10, scale: 2, default: 0.00
      t.string :password_digest
      t.string :token, null: false

      t.timestamps
    end
  end
end
