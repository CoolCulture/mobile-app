class FamilyCardsController < ApplicationController
  before_action :set_user

  def show
    response = { family_card: @family_card }
    
    if params["checkins"]
      response[:checkins] = @family_card.checkins.map do |checkin|
        { date: checkin.date.to_date.strftime("%B %d, %Y"), museum: checkin.museum.name,
          image: checkin.museum.image_url }
      end
    end
    
    render json: response
  end

  private
  
  def set_user
    @family_card = FamilyCard.find(params[:id])
  end
end
