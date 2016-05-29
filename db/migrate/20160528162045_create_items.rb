class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.float :geo
      t.datetime :order_key
    end
    add_index :items, :order_key
  end
end
