class Admin::OneTimeActivitiesController < ApplicationController
  before_action :set_activity, only: [:show, :edit, :update, :destroy]
  before_filter :is_admin?

  def index
    @museum = Museum.find(params[:museum_id])
    @activities = @museum.activities
  end

  def show
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

    if @activity.save
      redirect_to admin_museum_one_time_activities_path(@museum)
    else
      render action: 'new'
    end
  end

  def update
    if @activity.update(activity_params)
      redirect_to admin_museum_one_time_activity_path(@museum, @activity)
    else
      render action: 'edit'
    end
  end

  def destroy
    @activity.destroy
    redirect_to admin_museum_one_time_activities_path(@museum)
  end

  private

  def set_activity
    @museum = Museum.find(params[:museum_id])
    @activity = @museum.activities.find(params[:id])
  end

  def activity_params
    params.require(:one_time_activity).permit(:name, :description, :date, :start_time, :end_time, :featured)
  end
end
