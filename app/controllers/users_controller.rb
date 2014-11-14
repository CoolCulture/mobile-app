class UsersController < ApplicationController
  def create
    family_cards = FamilyCard.where(last_name: user_params[:last_name], pass_id: user_params[:pass_id])
    if family_cards.count != 1
      render status: 400, json: ["Invalid Last Name and/or Pass ID"]
    elsif family_cards[0].user
      render status: 400, json: ["An account has already been made for this Pass ID"]
    else
      user = User.new(email: user_params[:email], password: user_params[:password], family_card: family_cards[0])
      if user.save
        sign_in user
        render status: 201, json: {}
      else
        render status: 400, json: user.errors.full_messages
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :last_name, :pass_id)
  end
end