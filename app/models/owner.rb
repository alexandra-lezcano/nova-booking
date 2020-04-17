class Owner < ApplicationRecord
  has_one_attached :image
  has_one :user
  validates :image, presence: true
  validate :correct_image_type

  private
  def correct_image_type
    if image.attached? && !image.content_type.in?(%w(image/jpeg image/png))
      errors.add(:Debe, "seleccionar una imagen")
    elsif image.attached? == false
      errors.add(:Imagen, "de perfil requerida")
    end
  end

  resourcify
end
