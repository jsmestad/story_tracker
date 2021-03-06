class DefectFormatter
  include ActiveModel::Model

  attr_accessor :assumption, :actual, :workaround

  attr_accessor :name_expectation, :name_actual

  validates_presence_of :assumption, :actual, :workaround
  validates_presence_of :name_expectation, :name_actual

  def self.policy_class
    DefectPolicy
  end

  def workaround=(value)
    @workaround = if value.is_a?(String)
                    value == 'true' ? true : false
                  else
                    value
                  end
  end

  # What did you assume would happen?
  # What actually happened?
  # How easy is it to work around?

  # def description
    # #"As an #{stakeholder}, I want #{the_ask}, so that #{reasoning}."
    # ""
  # end

  def name
    "Expected #{name_expectation}, instead received #{name_actual}"
  end

  def workaround_sentence
    if workaround
      "**No**, there is no workaround."
    else
      "Yes, there is a workaround."
    end
  end

  def body
    body = %Q(
## Expected Behavior
#{assumption}

## Actual Behavior
#{actual}

### Workaround Available?
#{workaround_sentence}
)
  end

  def as_params
    p = { story_type: 'bug', description: body, name: name }
    # if self.after_id.present?
      # p.merge!(after_id: self.after_id.to_i)
    # end
    p
  end


end
