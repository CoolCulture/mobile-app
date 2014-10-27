class Admin::FamilyCardsController < ApplicationController
  before_action :set_user, only: [:show]
  before_filter :is_admin?

  def index
    @family_cards = FamilyCard.all
  end

  def show
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
  
  def set_user
    @user = User.find(params[:id])
  end
end
