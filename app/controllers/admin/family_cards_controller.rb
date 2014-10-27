class Admin::FamilyCardsController < ApplicationController
  before_action :set_family_card, only: [:show, :edit, :update, :destroy]
  before_filter :is_admin?

  def index
    @family_cards = FamilyCard.asc(:pass_id).page(params[:page])
  end

  def update
    if @family_card.update(family_card_params)
      redirect_to admin_family_card_path(@family_card), notice: 'Family Card was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @family_card.destroy
    redirect_to admin_family_cards_url
  end

  def import
    @family_cards = FamilyCard.scoped
    
    begin
      errors = FamilyCard.import(params[:file].path)

      flash.now[:notice] = "Family Cards imported successfully."
      @warnings = errors if errors.present?
    rescue Mongoid::Errors::UnknownAttribute
      flash.now[:error] = 'The CSV had an invalid column. Please check that all columns are valid.'
    rescue
      flash.now[:error] = "The file you have chosen is invalid. Please try again."
    end
    
    render :index
  end

  private

  def set_family_card
    @family_card = FamilyCard.find(params[:id])
  end

  def family_card_params
    params.require(:family_card).permit(:first_name, :last_name, 
    :expiration, :organization_name, :language)
  end
end
