class EstatesController < ApplicationController
  before_action :set_estate, only: %i[show edit update destroy]
  before_action :authenticate_user! , except: [:show, :room]

  include EstatesHelper
  load_and_authorize_resource
  # GET /estates
  # GET /estates.json
  def index
    owner = helpers.current_owner
    if owner
      (@filterrific = initialize_filterrific(
        Estate.estates_by_owner(owner.id),
        params[:filterrific]
      )) || return
      @estates = @filterrific.find.page(params[:page])

      respond_to do |format|
        format.html
        format.js
      end
    else
      @estates = []
    end

    render :index, locals: { estates: @estates }
  end

  # GET /estates/1
  # GET /estates/1.json
  def show
    (@filterrific = initialize_filterrific(
        Estate.with_rooms,
        params[:filterrific],
        select_options: {
            sorted_by: Estate.with_rooms.options_for_sorted_by,
        },
        )) || return
    @estates = @filterrific.find.page(params[:page])
    date_from_formatted = Date.parse(params[:from])
    date_to_formatted = Date.parse(params[:to])
    @diff = (date_to_formatted.to_date - date_from_formatted.to_date).to_i
    @plural_arg = (@diff > 1)? "s":" "
    date_from = params[:from]
    date_to = params[:to]
    price_max = ((params[:price_max] != '') && (params[:price_max] != nil)) ? params[:price_max] : 1000000000 #to do
    price_min = ((params[:price_min] != '') && (params[:price_min] != nil)) ? params[:price_min] : 0
    @rooms = @estate.rooms.available(params[:id], date_from, date_to, price_max, price_min)
    @rooms.each do |room|
      quantity_available = Room.quantity_available(room.id, date_from, date_to).first
      room.quantity =  quantity_available != nil ? quantity_available : 1
    end
    @facilities = @estate.facilities_estates
    @images = @estate.images

    respond_to do |format|
      format.html
      format.js
    end
    render :show, locals: {filterrific: @filterrific, city: params[:city], from: date_from, to: date_to}
  end

  # GET /estates/new
  def new
    owner = Owner.find_by(user_id: current_user.id)
    if owner
      @estate = Estate.new
      @estate.owner_id = owner.id
      @estate.status = false
      @rooms = @estate.rooms.build
      @room_facilities = Facility.where(facility_type: :room)
      @estate_facilities = Facility.where(facility_type: :estate)
      render :new, locals: { rooms: @rooms, estate_facilities: @estate_facilities}
    else
      redirect_to new_owner_path
    end
  end
  # GET /estates/new_room
  def new_room
    @room = Room.new
  end

  # GET /estates/1/edit
  # room_facilities: @room_facilities, estate_facilities: estate_facilities
  def edit
    owner = Owner.find_by_user_id(current_user.id)
    if owner
      @rooms = Room.where(:estate_id => params[:id])
      @room_facilities = Facility.where(facility_type: :room)
      @estate_facilities = Facility.where(facility_type: :estate)
    else
      redirect_to estates_path
    end
  end

  # POST /estates
  # POST /estates.json
  def create
    @estate = Estate.new(estate_params)
    @estate.isPublished

    respond_to do |format|
      if @estate.save
        format.html { redirect_to estates_url, notice: 'Propiedad creada exitosamente.' }
        format.json { render :show, status: :created, location: @estate }
      else
        format.html { render :new }
        format.json { render json: @estate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /estates/1
  # PATCH/PUT /estates/1.json
  def update
    respond_to do |format|
      if @estate.update(estate_params)
        format.html { redirect_to show_detail_estate_path, notice: 'Propiedad actualizada exitosamente.' }
        format.json { render :show, status: :ok, location: @estate }
      else
        format.html { render :edit }
        format.json { render json: @estate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /estates/1
  # DELETE /estates/1.json
  def destroy
    @estate.destroy
    respond_to do |format|
      format.html { redirect_to estates_url, notice: 'Propiedad eliminada exitosamente.' }
      format.json { head :no_content }
    end
  end

  # GET /estates/1/show_detail
  def show_detail
    @estate = Estate.find(params[:id])
    @rooms = @estate.rooms
    @facilities = @estate.facilities_estates
    @images = @estate.images
    render :show_detail, locals: { estate: @estate}
  end

  def room
    @room = Room.find(params[:id])
    respond_to do |format|
      format.js { }
    end
  end

  # dar de baja una propiedad
  def unsuscribe_estate
    estate = Estate.find(params[:estate_id])
    rooms = estate.rooms

    # filtra de la lista de habitaciones todas las que no estan reservadas
    booked_rooms = rooms.select do |room|
      BookingDetail.find_by_room_id(room.id)
    end

    # comprobar si alguna de las habitaciones reservadas esta ocupada
    free = true
    booked_rooms.each do |br|
      if Time.now.between?(date_start(br), date_end(br))
        free = false
      end
    end

    respond_to do |format|
      if free
        # actualizar estado de las habitaciones y de la propiedad
        rooms.each do |r|
          if r.status == 'published'
            r.update_attribute(:status, 'not_published')
          end
        end
        #actualizar el estado de la propiedad
        estate.update_attribute(:status, false)

        format.html { redirect_to estates_path, notice: 'Propiedad dada de baja exitosamente.' }
        format.json { head :no_content }
        UserMailer.unsuscribe_estate(estate, booked_rooms).deliver_now
      else
        format.html { redirect_to estates_path, alert: 'No se puede dar de baja esta propiedad. Una o mas habitaciones estan ocupadas.' }
        format.json { head :no_content }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_estate
    @estate = Estate.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def estate_params
    params.require(:estate).permit(:name, :address, :city_id, :owner_id, :estate_type, :description,facility_ids: [], images: [], rooms_attributes: [:id, :estate_id, :description, :capacity, :quantity, :price, :status, :room_type, :_destroy, facility_ids: [], images:[]])
  end

  def current_ability
    @current_ability ||= EstateAbility.new(current_user)
  end
end