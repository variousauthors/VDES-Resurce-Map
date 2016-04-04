class ServicesController < ApplicationController
  before_action :set_service, only: [:show, :edit, :update, :destroy]
  before_action :set_locations_attributes, only: [:create, :update]

  def index
    respond_to do |format|
      format.html { @services = Service.with_location.with_category_name.sort_by(&:name) }
    end
  end

  def print
    @service_categories = Service.with_location.with_category_name.sort_by(&:name).group_by(&:category_name)

    render layout: "print"
  end

  def show
    @service = Service.with_location.find(params[:id])
  end

  def new
    @service = Service.new
    @service.locations.build
  end

  def edit
    @service = Service.with_location.find(params[:id])
  end

  def create
    @service = Service.new(service_params)

    if @service.save
      redirect_to @service, notice: 'Service was successfully created.'
    else
      flash[:danger] = @service.errors.full_messages.to_sentence
      render :new
    end
  end

  def update

    # TODO also check if associations changed
    @service.attributes = service_params
    changed = @service.changed?

    if @service.save

      @service.update(modified_at: @service.updated_at) if changed

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

    def set_locations_attributes
      params[:service][:locations_attributes] = Array.wrap(params[:service].delete(:location))
    end

    # Only allow a trusted parameter "white list" through.
    def service_params
      params.require(:service).permit(:id, :name, :notes, :category_id, :tag_list, locations_attributes: [:id, :address, :phone])
    end
end
