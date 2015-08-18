class AdvancedStoryFormatter
  include ActiveModel::Model

  attr_accessor :name, :body

  def self.policy_class
    StoryPolicy
  end

  def initialize(params={})
    super
    self.name ||= initial_name
    self.body ||= initial_body
    return self
  end

  def initial_name
    "As a {database admin}, I want {slack integration}"
  end

  def initial_body
%Q(As a {database admin}, I want {slack integration},
In order to {accomplish what?}.

## What does it do now?

{provide command you run, what is the result now?}

## What does it do when completed?

{using that same command you use today, what is the new result?}

## Acceptance Criteria

{List all specific acceptance criteria, all use cases}

## Technical Notes

{Remove if not need. Any technical notes, specific classes, etc })
  end

  def as_params
    { story_type: 'feature', description: body, name: name}
  end

end
