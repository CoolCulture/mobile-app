class ActivitiesController < ApplicationController

  def upcoming
    date = Date.parse(params[:date]) rescue Date.today
    @activities = Activity.upcoming(date)
  end
end
