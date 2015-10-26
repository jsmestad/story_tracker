class UsersController < ApplicationController
  before_filter :authenticate_user!
  after_action :verify_authorized

  def show
    @user = params[:id] ? User.find_by_guid(params[:id]) : current_user
    authorize @user
  end

  def edit
    @user = User.find_by_guid(params[:id])
    authorize @user, :update?
  end

  def update
    @user = User.find_by_guid(params[:id])
    authorize @user

    if @user.update_attributes(permitted_attributes(@user))
      flash[:success] = 'Account updated successfully.'
      redirect_to user_path
    else
      flash[:alert] = 'An error occurred. Please resolve and try again.'
      render :edit
    end
  end

  def destroy
    user = User.find_by_guid(params[:id])
    authorize user
    user.destroy
    flash[:success] = 'User has been deleted.'
    redirect_to users_path
  end

private

  def user_params
    params.require(:user).permit(policy(@user).permitted_attributes)
  end

end
