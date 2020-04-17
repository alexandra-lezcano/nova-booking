namespace :booking do
  desc "Cambia el estate_state a false cuando termina la reserva"
  task finished: :environment do
    bookings = Booking.finished
    bookings.each do |booking|
      booking.booking_state = false
      booking.save
    end
  end

end
