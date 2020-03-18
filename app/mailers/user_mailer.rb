class UserMailer < ApplicationMailer
  def new_booking(booking)
    @booking =booking
    @user_email = user_email(booking)
    mail(to: booking.client_email, subject: 'NovaBooking!')
  end

  def new_booking_owner(booking)
    @booking =booking
    user_email = user_email(booking)
    mail(to: user_email, subject: 'NovaBooking!')
  end

  private
    #se obtiene el email del propietario
    def user_email(booking)
      estate_id = Room.find_by_id(booking.booking_details.first.room_id).estate_id
      estate = Estate.find_by_id(estate_id)
      user_id= Owner.find_by_id(estate.owner_id).user_id
      user_email = User.find_by_id(user_id).email
      return user_email
    end

end
