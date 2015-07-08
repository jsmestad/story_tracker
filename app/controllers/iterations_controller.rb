class IterationsController < ApplicationController
  def index
    @iterations = project.iterations(scope: 'current_backlog')
  end
end
