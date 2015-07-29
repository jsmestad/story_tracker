module StoryStateConcern
  extend ActiveSupport::Concern

  included do
    include AASM
    enum state: {submitted: 0, approved: 1, rejected: 2}

    aasm column: :state, enum: true do
      state :submitted, initial: true
      state :approved
      state :rejected

      event :approve, before: :send_to_tracker! do
        transitions from: :submitted, to: :approved
      end

      event :reject do
        transitions from: :submitted, to: :rejected
      end
    end
  end

  def send_to_tracker!
    story = user.connection.create_story(tracker_params_hash)
    if story.id.present?
      self.update_attribute(:external_ref, story.id)
    end
  rescue TrackerApi::Error
    false
  end

private

  def tracker_params_hash
    { name: name, description: description, after_id: after_id }
  end
end
