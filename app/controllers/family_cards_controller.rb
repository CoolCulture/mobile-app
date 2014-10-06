class FamilyCardsController < ApplicationController
  before_action :set_user, only: [:show]
  http_basic_authenticate_with name: ADMIN_USER, password: ADMIN_PASS, except: [:show]

  def index
    @family_cards = FamilyCard.all
  end

  # GET /family_card/1
  # GET /family_card/1.json
  def show
    expires_in 15.minutes
    response = { user: @user, family_card: @user.family_card }
    
    if params["checkins"]
      response[:checkins] = @user.family_card.checkins.map do |checkin|
        { date: checkin.date.to_date.strftime("%B %-d, %Y"), museum: checkin.museum.name,
          image: checkin.museum.imageUrl }
      end
    end

    render json: response
  end

  def import
    @family_cards = FamilyCard.scoped
    @warnings = []
    begin
      result = FamilyCard.import(params[:file].path)
      if result.empty?
        flash.now[:notice] = "Family Cards imported successfully."
      else
        result.each do |pass_id, errors|
          @warnings << "FamilyCard with pass id #{pass_id} has errors: " + errors.full_messages.join(",") + "\n"
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
  def set_user
    @user = User.find(params[:id])
  end
end
