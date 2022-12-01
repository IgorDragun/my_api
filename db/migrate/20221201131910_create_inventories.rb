class CreateInventories < ActiveRecord::Migration[6.1]
  def change
    create_table :inventories do |t|
      t.string :name, null: false, unique: true
      t.decimal :cost, null: false, precision: 10, scale: 2

      t.belongs_to :user

      t.timestamps
    end
  end
end
