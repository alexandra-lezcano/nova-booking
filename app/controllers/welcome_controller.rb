# frozen_string_literal: true

class WelcomeController < ApplicationController
  def index
    (@filterrific = initialize_filterrific(
        Estate,
        params[:filterrific],
        select_options: {
            sorted_by: Estate.options_for_sorted_by,
            with_any_facility_ids: Facility.options_for_select,
        },
        )) || return
    @estates = @filterrific.find.page(params[:page])

    respond_to do |format|
      format.html
      format.js
    end
  end
end
