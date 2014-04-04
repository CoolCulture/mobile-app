class CheckinController < ApplicationController
  before_action :set_checkin, only: [:show]

  # POST /checkin
  # POST /checkin.json
  def create
    museum = Museum.find(params[:museum_id])
    family_card = FamilyCard.find_or_initialize_by(id: params[:family_card_id])

    respond_to do |format|
      if family_card.valid_last_name(params[:last_name])
        @checkin = Checkin.new(checkin_params)
        @checkin.museum = museum
        @checkin.family_card = family_card
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

  def show
  end

  private
  def set_checkin
      @checkin = Checkin.find(params[:id])
    end

  def checkin_params
      params.require(:checkin).permit(:number_of_adults, :number_of_children)
  end

end
