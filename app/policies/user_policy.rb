class UserPolicy
  attr_reader :current_user, :model

  def initialize(current_user, model)
    @current_user = current_user
    @user = model
  end

  def index?
    @current_user.admin?
  end

  def show?
    @current_user.admin? or @current_user == @user
  end

  def update?
    @current_user.admin? or @current_user == @user
  end

  def destroy?
    return false if @current_user == @user
    @current_user.admin?
  end

  def permitted_attributes
    if @current_user.admin? and @current_user != @user
      [:api_key, :email_address, :role]
    elsif @current_user == @user
      [:api_key, :email_address]
    end
  end

end
