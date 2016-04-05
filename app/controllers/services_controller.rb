class ServicesController < ApplicationController
  before_action :set_service, only: [:show, :edit, :update, :destroy]
  before_action :set_locations_attributes, only: [:create, :update]

  def index
    respond_to do |format|
      format.html { @services = Service.with_location.with_category_name.sort_by(&:name) }
    end
  end

  def print
    services = sanitize_services(Service.with_location.with_category_name).sort_by(&:name)

    categories = services.group_by(&:category_name)
    categories.delete("Other") # TODO this is temporary

    by_size = categories.map { |k,v| [v.size, k] }

    # columns takes [[1, stuff...], [13, stuff...], [19, stuff], ...]
    @columns = partition(by_size, 4)

    @columns = @columns.map do |col|
      col.map do |cat|
        name = cat[1]
        [name, categories[name]]
      end
    end

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

    # data are tuples of the form [size, ...]
    # and we'll partition them based on size
    # returns tuples like [size, [size, ...], ...]
    def partition(data, n)
      parts = []
      n.times { parts.push([0]) }

      # the greedy method approximates a good partition
      data.length.times do |i|
        max = data.delete(data.max_by(&:first))

        min = parts.min_by(&:first)
        min[0] = min.first + max.first
        min.push(max)
      end

      parts.map {|p| p[1, p.size - 1]}
    end

    def sanitize_services(services)
      black_list = ["WISH Drop-In Centre Society", "Directions: Youth Services Centre", "Spartacus Books", "Main St. and Terminal Ave.", "Translink"]

      services = services.select do |service|
        !black_list.include?(service.name) && !black_list.include?(service.address)
      end
    end
end
