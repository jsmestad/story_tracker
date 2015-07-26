module AuthorizationConcern
  extend ActiveSupport::Concern

  included do
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  end

private

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore

    flash[:error] = t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default
    redirect_to(request.referrer || root_path) and return
  end
end
