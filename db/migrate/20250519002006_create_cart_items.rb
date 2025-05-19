class CreateCartItems < ActiveRecord::Migration[7.1]
  def change
    create_table :cart_items do |t|
      t.integer :product_id
      t.integer :cart_id
      t.integer :quantity, default: 0

      t.timestamps
    end

    add_index :cart_items, :cart_id
  end
end
