class CreateItems < ActiveRecord::Migration[6.1]
  def change
    create_table :items do |t|
      t.string :name, null: false, unique: true
      t.decimal :price, null: false, precision: 10, scale: 2
      t.integer :count, null: false, default: 0

      t.belongs_to :shop

      t.timestamps
    end
  end
end