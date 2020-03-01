class AddQuantityToRoom < ActiveRecord::Migration[6.0]
  def change
    add_column :rooms, :quantity, :integer
  end
end
