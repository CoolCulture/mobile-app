class FamilyCardsController < ApplicationController
  before_action :set_user

  def show
    expires_in 15.minutes
    response = { family_card: @user.family_card }
    
    if params["checkins"]
      response[:checkins] = @user.family_card.checkins.map do |checkin|
        { date: checkin.date.to_date.strftime("%B %d, %Y"), museum: checkin.museum.name,
          image: checkin.museum.image_url }
      end
    end
    
    render json: response
  end

  private
  
  def set_user
    @user = User.find(params[:id])
  end
end
