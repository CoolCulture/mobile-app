class OneTimeActivitiesController < ApplicationController
  before_action :set_activity, only: [:show, :edit, :update, :destroy]
  http_basic_authenticate_with name: ADMIN_USER, password: ADMIN_PASS, except: [:index, :show]

  def index
  end

  def show
    puts @activity.name
  end

  def new
    @museum = Museum.find(params[:museum_id])
    @activity = OneTimeActivity.new(museum: @museum)
  end

  def edit

  end

  def create
    @museum = Museum.find(params[:museum_id])
    @activity = OneTimeActivity.new(activity_params.merge(museum: @museum))

    respond_to do |format|
      if @activity.save
        format.html { redirect_to @museum, notice: 'Activity was successfully created.' }
        format.json { render action: 'show', status: :created, location: @museum }
      else
        format.html { render action: 'new' }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    respond_to do |format|
      if @activity.update(activity_params)
        format.html { redirect_to @museum, notice: 'Activity was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

def destroy
  @activity.destroy
  respond_to do |format|
    format.html { redirect_to @museum }
    format.json { head :no_content }
  end
end

  private
  def set_activity
    puts params
    @museum = Museum.find(params[:museum_id])
    puts @museum
    @activity = @museum.activities.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def activity_params
    params.require(:one_time_activity).permit(:name, :description, :date, :start_time, :end_time)
  end
end
