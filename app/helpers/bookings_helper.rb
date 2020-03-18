module BookingsHelper
  def room_type(f)
    Room.find(f.object.room_id).room_type.text
  end
  def room_capacity(f)
  Room.find(f.object.room_id).room_type.text
  end
end
