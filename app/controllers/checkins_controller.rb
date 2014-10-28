class CheckinsController < ApplicationController

  def show
    @checkin = Checkin.find(params[:id])
  end

  def create
    museum = Museum.find(params[:museum_id])
    family_card = FamilyCard.find_or_initialize_by(id: params[:family_card_id])

    respond_to do |format|
      if family_card.last_name == params[:last_name]
        @checkin = Checkin.new(checkin_params)
        @checkin.museum = museum
        @checkin.family_card = family_card
        @checkin.last_name = family_card.last_name
        @checkin.date = Date.today

        if @checkin.save
          format.json { render action: 'show', status: :created, location: @checkin }
        else
          format.json { render json: @checkin.errors, status: :unprocessable_entity }
        end
      else
          format.json { render json: @checkin, status: :unprocessable_entity }
      end
    end
  end

  private

  def checkin_params
    params.require(:checkin).permit(:number_of_adults, :number_of_children)
  end
end
