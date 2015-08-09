class Story < ActiveRecord::Base
  include StoryStateConcern
  include GuidConcern
  displayed_with_guid

  belongs_to :user, inverse_of: :stories

  validates :user, presence: true

  # validates :stakeholder, :the_ask, :reasoning, :error_expectation, :confirmation_flow, presence: true
  validates :name, :description, presence: true, if: :submitted?
  validates_inclusion_of :story_type, in: %w(feature bug), allow_nil: false
  # validates_presence_of :external_ref, if: :submitted?

  delegate :url, to: :external_story, allow_nil: true, if: :approved?

  def self.search(q)
    # where("name ILIKE ?", "%#{q}%")
    where("description ILIKE ?", "%#{q}%")
  end

  def self.create_from_formatter(user, params)
    create do |story|
      story.user = user
      story.name = params[:name]
      story.description = params[:description]
      story.after_id = params[:after_id]
      story.story_type = params[:story_type]
    end
  end

  def current_state
    if approved?
      external_story.try(:current_state)
    else
      self.state
    end
  end

  def estimate
    if approved?
      external_story.try(:estimate)
    else
      nil
    end
  end

  def handle_callback!(resource)
    if resource.kind == 'story_delete_activity'
      reject!
    else
      self.touch(:updated_at)
      if user.has_email_address?
        StoryMailer.updated_story_notification(user.email_address, self, resource.message).deliver_now
      end
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
    return nil unless external_ref.present?
    project.story(external_ref)
  rescue TrackerApi::Error => e
    nil
  end

  def project
    @story_project ||= TrackerProject.new
  end

end
