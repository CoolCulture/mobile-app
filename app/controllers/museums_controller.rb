class MuseumsController < ApplicationController
  skip_filter :deep_snake_case_params!
  before_action :set_museum, only: [:show, :edit, :update, :destroy]

  def index
    @museums = Museum.all
    expires_in 15.minutes
    fresh_when etag: @museums, last_modified: @museums.max(:updated_at), public: true
  end

  def show
    expires_in 15.minutes
    fresh_when @museum, public: true
  end

  private
  
  def set_museum
    @museum = Museum.find(params[:id])
  end
end
