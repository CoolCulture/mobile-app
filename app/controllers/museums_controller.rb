class MuseumsController < ApplicationController
  def index
    @museums = Museum.all
    expires_in 15.minutes
    fresh_when etag: @museums, last_modified: @museums.max(:updated_at), public: true
  end

  def show
    @museum = Museum.find(params[:id])
  end
end
