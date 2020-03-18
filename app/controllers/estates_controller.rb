class EstatesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_estate, only: %i[show edit update destroy]

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
    @rooms = @estate.rooms
    @facilities = @estate.facilities_estates
    @images = @estate.images
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
  def edit
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
        format.html { redirect_to @estate, notice: 'Propiedad actualizada exitosamente.' }
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

  # dar de alta una propiedad
  def suscribe
    @estate = Estate.find(params[:id])
    @estate.update_attribute(:status, true)
    respond_to do |format|
      format.html { redirect_to estates_url, notice: 'Propiedad publicada exitosamente.' }
      format.json { head :no_content }
    end
  end

  # dar de baja una propiedad
  def unsuscribe
    @estate = Estate.find(params[:id])
    @estate.update_attribute(:status, false)
    respond_to do |format|
      format.html { redirect_to estates_url, notice: 'Propiedad dada de baja exitosamente.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_estate
    @estate = Estate.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def estate_params

    params.require(:estate).permit(:name, :address, :city_id, :owner_id, :estate_type, :description,facility_ids: [], images: [], rooms_attributes: [:id, :estate_id, :description, :capacity, :quantity, :price, :status, :room_type, facility_ids: [], images:[]])

  end
end
