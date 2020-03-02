# frozen_string_literal: true

class Estate < ApplicationRecord
  belongs_to :city
  has_many_attached :images
  has_many :facilities_estates
  has_many :facilities, through: :facilities_estates
  has_many :rooms, dependent: :delete_all
  accepts_nested_attributes_for :rooms, allow_destroy: true
  belongs_to :owner
  # default for will_paginate
  self.per_page = 10

  filterrific :default_filter_params => { :sorted_by => 'name_asc' },
              :available_filters => %w[
                sorted_by
                search_query
                with_any_facility_ids
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
    num_or_conditions = 1
    where(
      terms.map do
        or_clauses = [
          'LOWER(cities.name) LIKE ?'
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
  end
