class DefectPolicy
  attr_reader :user, :defect

  def initialize(user, defect)
    @user = user
    @defect = defect
  end

  def index?
    user.admin?
  end

  def create?
    user.regular_user? or user.admin?
  end

  def update?
    user.admin?
  end
end
