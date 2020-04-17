class AddDefaultValuesToEstate < ActiveRecord::Migration[5.2]
  def change
    change_column :estates, :comments_rating_total,:integer, default: 0
    change_column :estates, :cant_comments,:integer, default: 0
  end
end
