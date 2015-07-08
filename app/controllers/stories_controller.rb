class StoriesController < ApplicationController
  def index
    @stories = project.stories
    render json: @stories.to_json
  end
end
