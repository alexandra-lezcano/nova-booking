class AddEstateToBooking < ActiveRecord::Migration[5.2]
  def change
    add_reference :bookings, :estate,  foreign_key: true
  end
end
