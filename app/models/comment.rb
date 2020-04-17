class Comment < ApplicationRecord
  belongs_to :estate
  validates :rating, presence: true

  def save_comment_with(params, email, name)
    self.description = params[:description]
    self.client_email = (email) ? email : params[:client_email]
    self.client_name = (name) ? name : params[:client_name]
    self.rating = params[:rating]
    self.estate_id = params[:estate_id]
    update_state(self.estate_id, self.rating) if self.save!
  end

  # actualizar propiedad con nueva valoracion
  # de ultimo comentario creado
  def update_state(estate_id, rating)
    estate = Estate.find(estate_id)
    estate.inc_comments
    estate.update_score(rating)
    estate.save
  end
end
