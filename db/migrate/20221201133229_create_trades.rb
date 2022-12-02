# frozen_string_literal: true

class CreateTrades < ActiveRecord::Migration[6.1]
  def change
    create_table :trades do |t|
      t.integer :initiator_id, null: false
      t.integer :receiver_id, null: false
      t.string :status, null: false, default: 'created'
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
