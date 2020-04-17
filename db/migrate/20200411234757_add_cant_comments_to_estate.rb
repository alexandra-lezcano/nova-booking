class AddCantCommentsToEstate < ActiveRecord::Migration[5.2]
  def change
    add_column :estates, :cant_comments, :integer
  end
end
