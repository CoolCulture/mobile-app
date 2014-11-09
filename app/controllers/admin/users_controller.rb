class Admin::UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :reset_password]
  before_filter :is_admin?

  def index
    search = params[:search]
    users = if search
              User.any_of({ email: /.*#{search}.*/i }).ascending(:email).to_a
            else 
              User.all.ascending(:email).to_a
            end

    @users = Kaminari.paginate_array(users).page(params[:page])
  end

  def update
    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path
  end

  def import
    @users = User.scoped
    
    begin
      results = User.import(params[:file].path)
      flash[:notice] = "Users imported successfully."
      @warnings = results[:errors] if results[:errors].present?

      AdminMailer.user_upload_report(current_user, results[:created_users], @warnings).deliver
    rescue Mongoid::Errors::UnknownAttribute
      flash[:error] = 'The CSV had an invalid column. Please check that all columns are valid.'
    rescue
      flash[:error] = "The file you have chosen is invalid. Please try again."
    end
    
    redirect_to admin_users_path
  end

  def reset_password
    AdminMailer.reset_password(current_user, @user).deliver
    flash.now[:notice] = "#{@user.email} has had their password reset."

    redirect_to admin_users_path
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email)
  end
end