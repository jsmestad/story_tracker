class UsersController < ApplicationController
  before_filter :authenticate_user!
  after_action :verify_authorized

  def index
    @users = User.order(:role, :name).all
    authorize @users
  end

  def show
    @user = current_user
    authorize @user
  end

  def edit
    @user = current_user
    authorize @user, :update?
  end

  def update
    @user = current_user
    authorize @user

    if @user.update_attributes(user_params)
      flash[:success] = 'Account updated successfully.'
      redirect_to user_path
    else
      flash[:alert] = 'An error occurred. Please resolve and try again.'
      render :edit
    end
  end

  def destroy
    user = User.find(params[:id])
    authorize user
    user.destroy
    flash[:success] = 'User has been deleted.'
    redirect_to users_path
  end

private

  def user_params
    params.require(:user).permit(:api_key, :email_address)
  end

end
