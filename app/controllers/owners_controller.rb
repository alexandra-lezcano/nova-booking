class OwnersController < ApplicationController

  before_action :authenticate_user! , except: :show
  before_action :set_owner, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  def index
    @owners = Owner.all
  end

  def show
    @owner = Owner.find(params[:id])
  end

  def new
    @owner = Owner.new
  end

  def edit
    @owner = Owner.find(params[:id])
  end

  def create
    @owner = Owner.new(owner_params)
    @owner.image = { data: params[:image] }
    respond_to do |format|
      if @owner.save
        format.html { redirect_to @owner, notice: 'Tu perfil de propietario fue creado satifactoriamente.' }
        format.json { render :show, status: :created, location: @owner }
      else
        format.html { render :new }
        format.json { render json: @owner.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @owner.image = { data: params[:image] }
    respond_to do |format|
      if @owner.update(owner_params)
        format.html { redirect_to @owner, notice: 'Tu perfil de propietario fue actualizado correctamente.' }
        format.json { render :show, status: :ok, location: @owner }
      else
        format.html { render :edit }
        format.json { render json: @owner.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @owner.destroy
    respond_to do |format|
      format.html { redirect_to owners_url, notice: 'Tu perfil de propietario fue eliminado satifactoriamente.' }
      format.json { head :no_content }
    end
  end

  private

  def set_owner
    @owner = Owner.find(params[:id])
  end

  def owner_params
    params.require(:owner).permit(:phone, :address, :about, :name, :email, :user_id)
  end

  def current_ability
    @current_ability ||= OwnerAbility.new(current_user)
  end
end
