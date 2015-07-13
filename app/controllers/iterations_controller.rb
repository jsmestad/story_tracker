class IterationsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @iterations = project.iterations(scope: 'current_backlog')
  end
end
