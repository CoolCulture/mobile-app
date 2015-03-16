class Admin::RecurringActivitiesController < ApplicationController
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
    @activity = RecurringActivity.new(museum: @museum)
    @existing_rule = nil
  end

  def edit
    @existing_rule = [IceCube::Rule.from_yaml(@activity.schedule)]
    @activity.schedule = nil
  end

  def create
    @museum = Museum.find(params[:museum_id])
    @activity = RecurringActivity.new(activity_params.merge(museum: @museum))
    
    if @activity.save
      redirect_to admin_museum_one_time_activities_path(@museum)
    else
      render action: 'new'
    end
  end

  def update
    if @activity.update(activity_params)
      redirect_to admin_museum_one_time_activities_path(@museum)
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
    params.require(:recurring_activity).permit(:name, :description, :date, :start_time, :end_time, :schedule)
  end
end