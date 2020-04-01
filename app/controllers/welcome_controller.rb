# frozen_string_literal: true

class WelcomeController < ApplicationController
  def index
    (@filterrific = initialize_filterrific(
        Estate,
        params[:filterrific],
        select_options: {
            sorted_by: Estate.options_for_sorted_by,
        },
        )) || return
    @estates = @filterrific.find.page(params[:page])

    respond_to do |format|
      format.html
      format.js
    end

    render :index, locals: { filterrific: @filterrific }
  end

  def results
    params[:filterrific]["price_min"] = params[:filterrific]["price_min"] == '' ? '0' : params[:filterrific]["price_min"]
    params[:filterrific]["price_max"] = params[:filterrific]["price_max"] == '' ? '1000000000' : params[:filterrific]["price_max"] #to do
    (@filterrific = initialize_filterrific(
        Estate,
        params[:filterrific],
        select_options: {
            sorted_by: Estate.options_for_sorted_by,
            with_estate_type: Estate.estate_type.options
        },
        )) || return
    @estates = @filterrific.find.page(params[:page])
    respond_to do |format|
      format.html
      format.js
    end
    render :results, locals: {filterrific: @filterrific}
  end

end
