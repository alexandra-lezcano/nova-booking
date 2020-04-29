class Booking < ApplicationRecord
    has_many :booking_details
    belongs_to :estate
    has_secure_token :confirmation_token
    accepts_nested_attributes_for :booking_details, :allow_destroy => true
    scope :request_assess, -> {where(cancelled_at: nil, booking_state: false, notified: false).where.not(confirmed_at: nil)}

    def self.booking_new(booking,params)
        booking.estate_id = params[:estate_id]
        booking.client_name = params[:client_name]
        booking.date_start = params[:date_start]
        booking.date_end = params[:date_end]
        booking.total_amount = params[:total_amount]
        booking.booking_state = true
        booking_details = JSON.parse(CGI.unescape(params[:booking_details]))
        booking_details.each {|value|
            booking.booking_details.build(room_id: value["room_id"],
                                           quantity: value["quantity"],
                                           subtotal: value["subtotal"])
        }
        booking
    end

    def self.set_state(booking)
        booking.confirmed_at = Time.now()
        booking.booking_state = true
        booking.save
        UserMailer.new_booking(booking).deliver_now
        UserMailer.new_booking_owner(booking).deliver_now
    end

    def self.estate(booking)
        Estate.find(Room.find(booking.booking_details[0].room_id).estate_id)
    end
    def self.diff(booking)
        return diff = (booking.date_end.to_date -  booking.date_start.to_date).to_i
    end

    scope :finished, -> {
        where("date_end <= ?  AND booking_state = true", DateTime.now.to_date)
    }
end
