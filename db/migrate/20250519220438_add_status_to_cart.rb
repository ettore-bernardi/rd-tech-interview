class AddStatusToCart < ActiveRecord::Migration[7.1]
  def up
    add_column :carts, :status, :integer, default: 0
  end
end
