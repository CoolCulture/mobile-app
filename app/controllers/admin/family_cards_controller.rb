class Admin::FamilyCardsController < ApplicationController
  before_action :set_family_card, only: [:show, :edit, :update, :destroy]
  before_filter :is_admin?

  def index
    search = params[:search]
    family_cards =  if search.to_i >= MINIMUM_PASS_ID
                      FamilyCard.find(search.to_i).to_a
                    elsif search
                      first = FamilyCard.any_of({ first_name: /.*#{search}.*/i }).ascending(:pass_id).to_a
                      last = FamilyCard.any_of({ last_name: /.*#{search}.*/i }).ascending(:pass_id).to_a
                      (first + last).uniq
                    else
                      FamilyCard.all.ascending(:pass_id).to_a
                    end

    @family_cards = Kaminari.paginate_array(family_cards).page(params[:page])
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
    begin
      errors = FamilyCard.import(params[:file].path)

      flash[:notice] = "Family Cards imported successfully."
      @warnings = errors if errors.present?
    rescue Mongoid::Errors::UnknownAttribute
      flash[:error] = 'The CSV had an invalid column. Please check that all columns are valid.'
    rescue
      flash[:error] = "Yikes. Something went wrong. The file you have chosen is either invalid
                       or the data is corrupted. Check for already existing Family Card IDs, a
                       malformed CSV, or other formatting issues."
    end
    
    @family_cards = FamilyCard.asc(:pass_id).page(params[:page])
    redirect_to admin_family_cards_path
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
