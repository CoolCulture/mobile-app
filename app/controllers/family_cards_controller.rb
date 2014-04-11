class FamilyCardsController < ApplicationController
  http_basic_authenticate_with name: ADMIN_USER, password: ADMIN_PASS

  def index
    @family_cards = FamilyCard.all
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
end
