class BookingDetail < ApplicationRecord
    has_many :rooms
    belongs_to :booking
end
