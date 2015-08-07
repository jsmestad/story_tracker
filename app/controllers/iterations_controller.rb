class IterationsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @iterations = project.iterations(scope: 'current_backlog')
    iceboxed_stories = Story.approved.where('external_ref IS NOT NULL').all
    if iceboxed_stories.empty?
      @icebox = []
    else
      @icebox = project.stories(filter: "state:unscheduled id:#{iceboxed_stories.map(&:external_ref).join(',')}")
    end
  end
end
