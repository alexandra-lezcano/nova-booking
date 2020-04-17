class AddScoreToEstates < ActiveRecord::Migration[5.2]
  def change
    add_column :estates, :score, :integer
  end
end
