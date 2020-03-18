class City < ApplicationRecord
  belongs_to :departament
  has_many :estates
  delegate :name, :to => :departament, :prefix => true
  self.per_page = 5
end
