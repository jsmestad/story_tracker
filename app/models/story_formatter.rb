class StoryFormatter
  include ActiveModel::Model

  attr_accessor :stakeholder, :the_ask, :reasoning, :details, :after_id,
    :error_expectation, :confirmation_flow

  validates_presence_of :stakeholder, :the_ask, :reasoning, :error_expectation, :confirmation_flow

  def self.policy_class
    StoryPolicy
  end

  def description
    "As an #{stakeholder}, I want #{the_ask}, so that #{reasoning}."
  end

  def name
    "As a #{stakeholder}, I want #{the_ask}"
  end

  def body
    body = %Q(
#{description}

## Acceptance Criteria

* #{error_expectation}
* #{confirmation_flow}
)
  end

  def as_params
    p = { story_type: 'feature', description: body, name: name}
    if self.after_id.present?
      p.merge!(after_id: self.after_id.to_i)
    end
    p
  end
end
