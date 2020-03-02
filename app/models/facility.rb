class Facility < ApplicationRecord
  has_and_belongs_to_many :rooms
  has_many :facilities_estates
  has_many :estates, through: :facilities_estates
  def self.options_for_select
    order("LOWER(description)").map { |e| [e.description, e.id] }
  end
end
