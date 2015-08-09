module StoryStateConcern
  extend ActiveSupport::Concern

  included do
    include AASM
    enum state: {submitted: 0, approved: 1, rejected: 2}

    aasm column: :state, enum: true do
      state :submitted, initial: true
      state :approved
      state :rejected

      event :approve, guard: :send_to_tracker!, after: :send_approved_notification! do
        transitions from: :submitted, to: :approved
      end

      event :reject, after: :send_reject_notification! do
        transitions from: :submitted, to: :rejected
      end
    end
  end

  def send_to_tracker!
    pt_story = user.connection.create_story(tracker_params_hash)
    if pt_story.id.present?
      self.update_attribute(:external_ref, pt_story.id)
    end
  rescue TrackerApi::Error
    false
  end

  def send_approved_notification!
    if user.has_email_address?
      StoryMailer.updated_story_notification(user.email_address, self, 'this request was approved for scheduling').deliver_now
    end
  end

  def send_reject_notification!
    if user.has_email_address?
      StoryMailer.rejected_story_notification(user.email_address, self).deliver_now
    end
  end

private

  def tracker_params_hash
    h = { name: name, description: description, story_type: story_type }
    h.merge!(after_id: after_id) if after_id.present?
    h
  end
end
