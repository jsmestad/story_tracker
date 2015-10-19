class StoryPolicy
  attr_reader :user, :story

  def initialize(user, story)
    @user = user
    @story = story
  end

  def index?
    user.admin?
  end

  def search?
    true
  end

  def show?
    true
  end

  def create?
    user.regular_user? or user.admin?
  end

  def update?
    if !user.viewer? and user == story.try(:user)
      if story.submitted?
        true
      else
        false
      end
    else
      false
    end
  end
end
