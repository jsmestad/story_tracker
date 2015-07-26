class Story < ActiveRecord::Base
  belongs_to :user, inverse_of: :stories

  validates :user, presence: true

  delegate :url, :name, :description, :current_state, to: :external_story, allow_nil: true

  # def method_missing(method, *args, &block)
    # external_story.send(method, *args, &block)
  # end

  def handle_callback!(resource)
    self.touch(:updated_at)
    if user.has_email_address?
      StoryMailer.updated_story_notification(user.email_address, self, resource.message).deliver_now
    end
  end

  def is_subscribed?
    self.subscribe
  end

  def subscribe!
    update_attribute(:subscribe, true)
  end

  def unsubscribe!
    update_attribute(:subscribe, false)
  end

private

  def external_story
    project.story(external_ref)
  rescue TrackerApi::Error => e
    nil
  end

  def project
    @story_project ||= TrackerProject.new
  end

end
