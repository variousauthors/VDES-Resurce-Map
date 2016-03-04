class ServicesController < ApplicationController
  before_action :set_service, only: [:show, :edit, :update, :destroy]

  def index
    @services = Service.with_location.all
  end

  def show
    @service = Service.with_location.find(params[:id])
  end

  def new
    @service = Service.new
  end

  def edit
    @service = Service.with_location.find(params[:id])
  end

  def create
    location = params[:service].delete(:location)
    @service = Service.new(service_params)

    @service.location = Location.create(location.permit(:address, :phone))

    if @service.save
      redirect_to @service, notice: 'Service was successfully created.'
    else
      render :new
    end
  end

  def update
    location = params[:service].delete(:location)
    @service = Service.with_location.find(params[:id])

    @service.location = Location.create(location.permit(:address, :phone))

    if @service.update(service_params)
      redirect_to @service, notice: 'Service was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @service.destroy
    redirect_to services_url, notice: 'Service was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service
      @service = Service.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def service_params
      params.require(:service).permit(:name, :category_id, :tag_list)
    end
end
