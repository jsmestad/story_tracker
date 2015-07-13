class SessionsController < ApplicationController

  def new
    redirect_to '/auth/github'
  end

  def create
    auth = request.env["omniauth.auth"]
    user = User.find_with_omniauth(auth) || User.create_with_omniauth(auth)
    reset_session
    session[:user_id] = user.id
    flash[:success] = "Logged In!"
    redirect_to iterations_path
  end

  def failure
    flash[:alert] = "Authentication error: #{params[:message].humanize}"
    redirect_to root_url
  end

  def destroy
    logout!
    flash[:notice] = "Logged out!"
    redirect_to root_url
  end
end
