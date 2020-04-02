class AddDeletedAtToEstates < ActiveRecord::Migration[5.2]
  def change
    add_column :estates, :deleted_at, :datetime
    add_index :estates, :deleted_at
  end
end
