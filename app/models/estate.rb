# frozen_string_literal: true
class Estate < ApplicationRecord
  acts_as_paranoid
  belongs_to :city
  has_many_attached :images
  has_many :bookings
  has_many :offers
  has_many :comments
  has_many :facilities_estates
  has_many :facilities, through: :facilities_estates
  has_many :rooms, dependent: :destroy
  accepts_nested_attributes_for :rooms, allow_destroy: true,
                                reject_if: :all_blank
  belongs_to :owner
  delegate :name, :to => :city, :prefix => true
  # default for will_paginate
  self.per_page = 5

  scope :estates_by_owner, -> (current_owner_id) { where(owner_id: current_owner_id) }
  scope :best_estates, -> () {
    order("estates.score desc, (select count(id) from bookings where estate_id = estates.id) desc")
  }
  scope :estates_by_client, -> (client_email) {
    where("estates.id in (
            select distinct b.estate_id
		        from bookings as b
		        where b.client_email = ?
          )", client_email)
  }
  scope :only_published, -> { where(status: true) }
  scope :with_rooms, -> {Estate.only_published.joins(:rooms).where('rooms.quantity > 0').group(:id)}

  # filters on 'estate_type' attribute
  scope :with_estate_type, ->(estate_types) {
    where(estate_type: [*estate_types])
  }

  filterrific :default_filter_params => {:sorted_by => 'name_asc'},
              :available_filters => %w[
                sorted_by
                search_query
                with_date_lte
                with_date_gte
                price_min
                price_max
                score_min
                score_max
                with_estate_type
              ]

  scope :search_query, lambda { |query|
    return nil if query.blank?

    # condition query, parse into individual keywords
    terms = query.to_s.downcase.split(/\s+/)
    # replace "*" with "%" for wildcard searches,
    # append '%', remove duplicate '%'s
    terms = terms.map { |e| ('%' + e.gsub('*', '%') + '%').gsub(/%+/, '%') }
    # configure number of OR conditions for provision
    # of interpolation arguments. Adjust this if you
    # change the number of OR conditions.
    num_or_conditions = 2
    where(
      terms.map do
        or_clauses = [
          'LOWER(cities.name) LIKE ?',
          'LOWER(estates.name) LIKE ?'
        ].join(' OR ')
        "(#{or_clauses})"
      end.join(' AND '),
      *terms.map { |e| [e] * num_or_conditions }.flatten
    ).joins(:city).references(:cities)
  }

  scope :sorted_by, ->(sort_option) {
    # extract the sort direction from the param value.
    direction = sort_option =~ /desc$/ ? 'desc' : 'asc'
    estates = Estate.arel_table
    case sort_option.to_s
    when /^name_/
      order(estates[:name].send(direction))
    else
      raise(ArgumentError, "Invalid sort option: #{sort_option.inspect}")
    end
  }

  def self.options_for_sorted_by
    [
        ['Name (A-Z)', 'name_asc'],
        ['Name (Z-A)', 'name_desc']
    ]
  end

  extend Enumerize
  enumerize :estate_type, in: [:one_apartment, :home, :hotel]

  scope :with_date_gte, ->(ref_date) {
    Estate.only_published.where("estates.id in
    ( select distinct ro.estate_id
     from public.rooms as ro
     where ro.id not in
         ( select distinct r.id
          from public.rooms as r
          join public.booking_details as bd on bd.room_id = r.id
          join public.bookings as b on b.id = bd.booking_id
          where b.booking_state != false
            and (r.quantity -
                   (select coalesce(sum(bd1.quantity),0)
                    from public.rooms as r1
                    join public.booking_details as bd1 on bd1.room_id = r1.id
                    join public.bookings as b1 on b1.id = bd1.booking_id
                    where b1.booking_state != false
                      and r1.id = r.id
                      and ((b1.date_start >= ?) or (b1.date_end >= ?)", ref_date, ref_date)
  }

  scope :with_date_lte, ->(ref_date) {
    Estate.only_published.where("((b1.date_end <= ?) or (b1.date_start <= ?)))) <= 0)))", ref_date, ref_date).order(score: :desc)
  }

  # filters on 'price' attribute
  scope :price_min, ->(price_min) {
    where("(? <= r.price)))", price_min)
  }

  scope :price_max, ->(price_max) {
    where("estates.id in (select distinct estate_id
      from rooms r
      where
        ((? >= r.price)", price_max)
  }
  # filters on 'score' attribute
  scope :score_min, ->(score_min) {
    where("? <= score", score_min)
  }

  scope :score_max, ->(score_max) {
    where("? >= score", score_max)
  }

  def isPublished
    self.status = self.rooms.any? {|room| room.status == "published"}
  end

  def commentsEstate
    Comment.where(estate_id: self.id)
  end

  def update_score(rating)
    cant_comments = self.comments_quant
    comments_rating_total = self.comments_rating_total + rating
    new_score = comments_rating_total / cant_comments
    self.comments_rating_total = comments_rating_total
    self.score = new_score
  end

  def inc_comments
    self.comments_quant += 1
  end

  resourcify
end
