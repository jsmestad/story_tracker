class ApplicationController < ActionController::Base
  layout 'application_v2'

  include Pundit
  include AuthorizationConcern
  include RedirectedLoginConcern

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from TrackerApi::Error, with: :verify_api_key_works

  def verify_api_key_works(exception)
    if exception.response[:status] == 403 and user_signed_in? and current_user.has_api_key?
      @project = TrackerProject.new
      flash[:alert] = "It appears your Pivotal Tracker API no longer works. Please remove or update it."
      redirect_to edit_user_path(current_user)
    else
      raise
    end
  end

  def project
    @project ||= if user_signed_in?
                   current_user.connection
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
      @current_user ||= if session[:user_id]
                          User.find_by_guid(session[:user_id])
                        end
    rescue Exception
      nil
    end

    def user_signed_in?
      return true if current_user
    end

    def correct_user?
      @user = User.find_by_guid(params[:id])
      unless current_user == @user
        redirect_to root_url, :alert => "Access denied."
      end
    end

    def authenticate_user!
      case request.format
      when Mime::JSON
        if user = authenticate_token
          @current_user = user
        else
          render_unauthorized
        end
      else
        if !current_user
          remember_location! unless request.url == login_url
          redirect_to login_url, alert: 'You need to sign in for access to this page.'
        end
      end
    end

    def authenticate_token
      authenticate_with_http_token do |token, options|
        User.find_by(token: token)
      end
    end

    def render_unauthorized
      self.headers['WWW-Authenticate'] = 'Token realm="Application"'
      render json: 'Bad credentials', status: 401
    end

end
