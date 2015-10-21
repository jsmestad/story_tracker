module StoryStateConcern
  extend ActiveSupport::Concern

  included do
    include AASM
    enum state: {submitted: 0, approved: 1, rejected: 2, completed: 3}

    aasm column: :state, enum: true do
      state :submitted, initial: true
      state :approved
      state :rejected
      state :completed

      event :approve, guard: :send_to_tracker!, after: :send_approved_notification! do
        transitions from: :submitted, to: :approved
      end

      event :complete do
        transitions from: :approved, to: :completed
      end

      event :reject, after: [:remove_external_ref!, :send_reject_notification!] do
        transitions from: [:submitted, :approved], to: :rejected
      end
    end

    scope :in_flight, -> { where('state != ?', self.states[:rejected]) }
  end

  def remove_external_ref!
    update_attribute(:external_ref, nil)
  end

  def send_to_tracker!
    if result = story_service.create
      update_attribute(:external_ref, result.id)
    else
      return false
    end
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

end
