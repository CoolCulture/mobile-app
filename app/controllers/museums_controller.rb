class MuseumsController < ApplicationController
  skip_filter :deep_snake_case_params!

  before_action :set_museum, only: [:show, :edit, :update, :destroy]
  http_basic_authenticate_with name: ADMIN_USER, password: ADMIN_PASS, except: [:index, :show]

  # GET /museums
  # GET /museums.json
  def index
    @museums = Museum.all
    expires_in 15.minutes
    fresh_when etag: @museums, last_modified: @museums.max(:updated_at), public: true
  end

  # GET /museums/1
  # GET /museums/1.json
  def show
    expires_in 15.minutes
    fresh_when @museum, public: true
  end

  # GET /museums/new
  def new
    @museum = Museum.new
  end

  # GET /museums/1/edit
  def edit
  end

  # POST /museums
  # POST /museums.json
  def create
    @museum = Museum.new(museum_params)

    respond_to do |format|
      if @museum.save
        format.html { redirect_to @museum, notice: 'Museum was successfully created.' }
        format.json { render action: 'show', status: :created, location: @museum }
      else
        format.html { render action: 'new' }
        format.json { render json: @museum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /museums/1
  # PATCH/PUT /museums/1.json
  def update
    respond_to do |format|
      if @museum.update(museum_params)
        format.html { redirect_to @museum, notice: 'Museum was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @museum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /museums/1
  # DELETE /museums/1.json
  def destroy
    @museum.destroy
    respond_to do |format|
      format.html { redirect_to museums_url }
      format.json { head :no_content }
    end
  end

  def import
    @museums = Museum.all
    @warnings = []
    begin
      result = Museum.import(params[:file].path)
      if result.empty?
        flash.now[:notice] = "Museums imported successfully."
      else
        result.each do |name_id, errors|
          @warnings << "#{name_id} has errors: " + errors.full_messages.join(",") + "\n"
        end
      end
    rescue Mongoid::Errors::UnknownAttribute
      flash.now[:error] = 'The CSV had an invalid column. Please check that all columns are valid.'
    rescue
      flash.now[:error] = "The file you have chosen is invalid. Please try again."
    end
    render action: :index
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_museum
      @museum = Museum.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def museum_params
      params.require(:museum).permit(:name, :phone_number, :address, :borough, :site_url,
        :image_url, :bus_lines, :additional_directional_info, 
        :wifi, :handicap_accessible, :hands_on_activity, :description,
        :free_admission, :suggested_donation, categories: [], hours: [], subway_lines: [],
        activity1: [:name, :time, :description], activity2: [:name, :time, :description],
        activity3: [:name, :time, :description])
    end
end
