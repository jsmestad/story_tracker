class SessionsController < ApplicationController

  def new
    redirect_to '/auth/github'
  end

  def create
    auth = request.env["omniauth.auth"]
    user = User.find_with_omniauth(auth) || User.create_with_omniauth(auth)
    reset_session
    session[:user_id] = user.id
    redirect_to root_path, success: "Logged In!"
  end

  def failure
    redirect_to root_url, alert: "Authentication error: #{params[:message].humanize}"
  end

  def destroy
    reset_session
    redirect_to root_url, notice: "Logged out!"
  end
end
