class DefectFormatter
  include ActiveModel::Model

  attr_accessor :assumption, :actual, :workaround

  def self.policy_class
    StoryPolicy
  end

  # What did you assume would happen?
  # What actually happened?
  # How easy is it to work around?

  def description
    #"As an #{stakeholder}, I want #{the_ask}, so that #{reasoning}."
  end

  def name
    #"As a #{stakeholder}, I want #{the_ask}"
  end

  def body
    # body = %Q(
# #{description}

# ## Acceptance Criteria

# * #{error_expectation}
# * #{confirmation_flow}
# )
  end


end
