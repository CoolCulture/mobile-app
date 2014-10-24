class Admin::MuseumsController < ApplicationController
  before_action :set_museum, except: [:index, :import, :new, :create]  
  before_filter :is_admin?

  def index
    @museums = Museum.all
  end

  def new
    @museum = Museum.new
  end

  def create
    @museum = Museum.new(museum_params)
    if @museum.save
      redirect_to admin_museum_path(@museum), notice: 'Museum was successfully created.'
    else
      render :new
    end
  end

  def update
    if @museum.update(museum_params)
      redirect_to admin_museum_path(@museum), notice: 'Museum was successfully created.'
    else
      render :edit
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

  def destroy
    @museum.destroy
    redirect_to admin_museums_url
  end

  private

  def set_museum
    @museum = Museum.find(params[:id])
  end
  
  def museum_params
    params.require(:museum).permit(:name, :phone_number, :address, :borough, :site_url,
      :image_url, :bus_lines, :wifi, :handicap_accessible, :hands_on_activity, :description,
      :free_admission, :suggested_donation, categories: [], hours: [], subway_lines: [],
      activity1: [:name, :time, :description], activity2: [:name, :time, :description],
      activity3: [:name, :time, :description])
  end
end