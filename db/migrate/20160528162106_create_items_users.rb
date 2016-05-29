class CreateItemsUsers < ActiveRecord::Migration
  def change
    create_table :items_users do |t|
      t.references :item, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.datetime :order_key
    end
    add_index :items_users, :order_key
  end
end
