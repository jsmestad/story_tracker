class StoryPolicy
  attr_reader :user, :story

  def initialize(user, story)
    @user = user
    @story = story
  end

  def index?
    user.admin?
  end

  def create?
    user.regular_user? or user.admin?
  end
end
