class SessionsController < ApplicationController

  def new
    redirect_to '/auth/github'
  end

  def create
    auth = request.env["omniauth.auth"]
    user = User.find_with_omniauth(auth) || User.create_with_omniauth(auth)
    if verify_github_org(user, auth)
      reset_session
      session[:user_id] = user.to_param
      if user.email_address.present?
        flash[:success] = "Logged In!"
        redirect_to iterations_path
      else
        flash[:notice] = "You are logged in. Please set your email address in the form below."
        redirect_to edit_user_path(user)
      end
    else
      flash[:alert] = "You do not have sufficient permissions."
      redirect_to root_url
    end
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

private

  def verify_github_org(user, auth)
    return true if Rails.env.test? # TODO need a better way to mock this

    client = Octokit::Client.new(access_token: auth['credentials']['token'])
    # NOTE check TEAM member with client.team_member?(ENV['ADMIN_TEAMID'], client.user.login)
    if ENV.has_key?('ORG_NAME') && client.org_member?(ENV['ORG_NAME'], client.user.login)
      true
    else
      false
    end
  end
end
