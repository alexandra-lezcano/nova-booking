class Room < ApplicationRecord
  acts_as_paranoid
  belongs_to :estate

  has_many :facilities_rooms
  has_many :facilities, through: :facilities_rooms
  has_many_attached :images
  has_many :booking_detail

  extend Enumerize

  enumerize :room_type, in: [:single, :double, :family]
  enumerize :status, in: [:published, :not_published]

  scope :available, ->(estate_id, from, to, price_max, price_min) {
    where(
        "rooms.id in (select distinct ro.id
          from public.rooms as ro
          where ro.estate_id = ?
          and ? <= ro.price
          and ? >= ro.price
          and ro.id not in
            (select distinct r.id
              from public.rooms as r
              join public.booking_details as bd on bd.room_id = r.id
              join public.bookings as b on b.id = bd.booking_id
              where b.booking_state != false
                and (r.quantity -
                  (select coalesce(sum(bd1.quantity), 0)
                  from public.rooms r1
                  join public.booking_details as bd1 on bd1.room_id = r1.id
                  join public.bookings as b1 on b1.id = bd1.booking_id
                  where b1.booking_state != false
                    and r1.id = r.id
                    and ((b1.date_start >= ?) or (b1.date_end >= ?))
                    and ((b1.date_end <= ?) or (b1.date_start <= ?)))) <= 0))", estate_id, price_min, price_max,from, from, to, to
    )
  }

  #Room.quantity_available('6','2020-04-01','2020-04-04')
  scope :quantity_available, ->(id, from, to) {
    where(
        "quantity in (select r2.quantity - (select coalesce(sum(bd.quantity), 0)
          from public.rooms as r
          join public.booking_details as bd on bd.room_id = r.id
          join public.bookings as b on b.id = bd.booking_id
          where b.booking_state != false
            and r.id = ?
            and ((b.date_start >= ?) or (b.date_end >= ?))
            and ((b.date_end <= ?) or (b.date_start <= ?)))
        from public.rooms as r2
        where r2.id = ?)", id, from, from, to, to, id
    ).pluck(:quantity).take(1)
  }

  def self.room_type_for(id)
    find(id).room_type.text
  end
  def self.room_capacity_for(id)
    find(id).capacity
  end

  scope :booking_details, -> { BookingDetail.joins(:room) }

end
