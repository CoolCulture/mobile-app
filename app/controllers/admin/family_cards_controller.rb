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
      result = FamilyCard.import(params[:file].path)
      success = result[:created_users].count

      flash.now[:notice] = "#{success} Family Cards imported successfully." if success > 0
      @warnings = format_errors(result[:errors]) if result[:errors]      
    rescue Mongoid::Errors::UnknownAttribute
      flash.now[:error] = 'The CSV had an invalid column. Please check that all columns are valid.'
    rescue
      flash.now[:error] = "The file you have chosen is invalid. Please try again."
    end
    render action: :index
  end

  private
  
  def format_errors(results)
    response = []
    results.each do |key, all_errors|
      message = ["(#{key})"]
      all_errors.each do |model, error_messages|
        message << "#{model} has an error:"
        error_messages.each do |kind, messages|
          message << "#{kind} #{messages.join(',')};"
        end
      end

      response << (message.join(" ") + "\n")
    end

    response
  end

  def set_user
    @user = User.find(params[:id])
  end
end
