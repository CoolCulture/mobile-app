class ActivitiesController < ApplicationController

  def upcoming
    start_date = Date.parse(params[:start_date]) rescue Date.today
    end_date = Date.parse(params[:end_date]) rescue start_date + 7.days
    grouped_activities = Activity.upcoming(start_date, end_date).group_by {|a| a.date}
    @days = (start_date..end_date).map {|day| {date: day, activities: grouped_activities[day] || []}}
  end
end
