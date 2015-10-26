class IterationsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @iterations = if params[:scope] == 'done'
                    project.iterations(scope: 'done', offset: -3)
                  else
                    project.iterations(scope: 'current_backlog')
                  end
    # iceboxed_stories = Story.approved.where('external_ref IS NOT NULL').all
    # if iceboxed_stories.empty?
      # @icebox = []
    # else
      # @icebox = project.stories(filter: "state:unscheduled id:#{iceboxed_stories.map(&:external_ref).join(',')}")
    # end

    render template: 'iterations/revised_index'
  end
end
