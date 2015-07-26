class ApplicationController < ActionController::Base
  include Pundit
  include AuthorizationConcern

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from TrackerApi::Error, with: :verify_api_key_works

  def verify_api_key_works(exception)
    if exception.response[:status] == 403 and user_signed_in? and current_user.has_api_key?
      @project = TrackerProject.new
      flash[:notice] = "It appears your Pivotal Tracker API no longer works. Please remove or update it."
      redirect_to edit_user_path
    else
      raise
    end
  end

  def project
    @project ||= if user_signed_in? && current_user.has_api_key?
                   TrackerProject.new(api_token: current_user.api_key)
                 else
                   TrackerProject.new
                 end
  end

  helper_method :current_user
  helper_method :user_signed_in?
  helper_method :correct_user?

  private

    def logout!
      reset_session
      session.destroy
      @current_user = nil
    end

    def current_user
      begin
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
      rescue Exception => e
        nil
      end
    end

    def user_signed_in?
      return true if current_user
    end

    def correct_user?
      @user = User.find(params[:id])
      unless current_user == @user
        redirect_to root_url, :alert => "Access denied."
      end
    end

    def authenticate_user!
      if !current_user
        redirect_to login_url, :alert => 'You need to sign in for access to this page.'
      end
    end

end
