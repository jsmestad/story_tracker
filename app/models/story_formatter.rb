class StoryFormatter
  include ActiveModel::Model

  attr_accessor :stakeholder, :the_ask, :reasoning, :details, :after_id

  attr_accessor :error_expectation, :confirmation_flow

  validates_presence_of :stakeholder, :the_ask, :reasoning

  def description
    "As an #{stakeholder}, I want #{the_ask}, so that #{reasoning}."
  end

  def name
    "#{the_ask}"
  end

  def as_params
    p = { description: description, name: name }
    if self.after_id.present?
      p.merge!(after_id: self.after_id.to_i)
    end
    p
  end
end
