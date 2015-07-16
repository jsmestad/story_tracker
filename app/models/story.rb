class Story < ActiveRecord::Base
  belongs_to :user, inverse_of: :stories

  validates :user, presence: true

  delegate :url, :name, :description, :current_state, to: :external_story, allow_nil: true

  # def method_missing(method, *args, &block)
    # external_story.send(method, *args, &block)
  # end

private

  def external_story
    project.story(external_ref)
  end

  def project
    @project ||= TrackerProject.new
  end

end
