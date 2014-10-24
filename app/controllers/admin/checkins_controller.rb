class Admin::CheckinsController < ApplicationController
  before_filter :is_admin?

  def index
    @checkins = Checkin.all
  end

  def show
    @checkin = Checkin.find(params[:id])
  end
end
