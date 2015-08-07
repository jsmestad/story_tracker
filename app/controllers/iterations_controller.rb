class IterationsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @iterations = project.iterations(scope: 'current_backlog')
    @icebox = project.stories(filter: "state:unscheduled id:#{Story.approved.map(&:external_ref).join(',')}")
  end
end
