class Story < ActiveRecord::Base
  include StoryStateConcern

  belongs_to :user, inverse_of: :stories

  validates :user, presence: true

  # validates :stakeholder, :the_ask, :reasoning, :error_expectation, :confirmation_flow, presence: true
  validates :name, :description, presence: true, if: :submitted?

  delegate :url, :current_state, to: :external_story, allow_nil: true, if: :approved?

  def self.create_from_formatter(user, params)
    create do |story|
      story.user = user
      story.name = params[:name]
      story.description = params[:description]
      story.after_id = params[:after_id]
    end
  end

  def story_type
    if approved?
      external_story.story_type
    else
      'feature'
    end
  end

  def current_state
    if approved?
      external_store.current_state
    else
      self.state
    end
  end

  def estimate
    if approved?
      external_store.estimate
    else
      nil
    end
  end

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
