module StoryStateConcern
  extend ActiveSupport::Concern

  included do
    include AASM
    enum state: {submitted: 0, approved: 1, rejected: 2}

    aasm column: :state, enum: true do
      state :submitted, initial: true
      state :approved
      state :rejected

      event :approve, guard: :send_to_tracker! do
        transitions from: :submitted, to: :approved
      end

      event :reject do
        transitions from: :submitted, to: :rejected
      end
    end
  end

  def send_to_tracker!
    pt_story = user.connection.create_story(tracker_params_hash)
    if pt_story.id.present?
      self.update_attribute(:external_ref, pt_story.id)
    # else
      # false
    end
  rescue TrackerApi::Error
    false
  end

private

  def tracker_params_hash
    h = { name: name, description: description}
    h.merge!(after_id: after_id) if after_id.present?
    h
  end
end
