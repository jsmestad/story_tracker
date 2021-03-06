class Story < ActiveRecord::Base
  include FilterableConcern

  include PgSearch
  multisearchable :against => [:guid, :name, :description, :external_ref]

  has_paper_trail meta: { comment: :comment }, on: [:create, :update]
  attr_accessor :comment

  include StoryStateConcern
  include GuidConcern
  displayed_with_guid

  acts_as_followable

  belongs_to :user, inverse_of: :stories

  has_many :activities, -> { order('created_at DESC') }, class_name: 'StoryCallback', inverse_of: :story, dependent: :destroy

  validates :user, presence: true

  # validates :stakeholder, :the_ask, :reasoning, :error_expectation, :confirmation_flow, presence: true
  validates :name, :description, presence: true, if: :submitted?
  validates_inclusion_of :story_type, in: %w(feature bug chore), allow_nil: false
  # TODO validates_numericality_of :estimate, only_integer: true, allow_nil: true
  # validates_presence_of :external_ref, if: :submitted?

  scope :feature, -> { where(story_type: 'feature') }
  scope :defect, -> { where(story_type: 'bug') }

  # delegate :url, to: :external_story, allow_nil: true, if: :approved?

  before_destroy do
    self.versions.destroy_all
  end

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

  def self.import_from_pivotal!(external_ref)
    new_story = self.new(external_ref: external_ref)
    new_story.story_service.pull

    new_story.state = 'approved'
    new_story.user = User.admin.first # TODO should find a way to discover users
    new_story.comment = 'Automatically imported from Pivotal Tracker callback'

    new_story.save!
  end

  def additional_description
    @additional_description
  end

  def additional_description=(addtl)
    @additional_description = addtl
    self.description += "\n#{@additional_description}"
  end

  def current_state
    # if approved?
      # external_story.try(:current_state)
    # else
      self.state
    # end
  end

  def handle_callback!(resource)
    if resource.kind == 'story_delete_activity'
      reject!
    else
      self.touch(:updated_at)
      # if user.has_email_address?
        # StoryMailer.updated_story_notification(user.email_address, self, resource.message).deliver_now
      # end
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

  def latest_description
    description
    # if external_ref
      # external_story.try(:description)
    # end
  end

  def story_service
    PivotalTracker::StoryService.new(self)
  end

end
