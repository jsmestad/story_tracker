class UsersController < ApplicationController
  before_filter :authenticate_user!

  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update_attributes(user_params)
      flash[:success] = 'Account updated successfully.'
      redirect_to user_path
    else
      flash[:alert] = 'An error occurred. Please resolve and try again.'
      render :edit
    end
  end

private

  def user_params
    params.require(:user).permit(:api_key, :email_address)
  end

end
