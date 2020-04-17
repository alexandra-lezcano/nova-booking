class AddCommentsRatingTotalToEstate < ActiveRecord::Migration[5.2]
  def change
    add_column :estates, :comments_rating_total, :integer
  end
end
