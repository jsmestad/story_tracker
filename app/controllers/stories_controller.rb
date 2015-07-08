class StoriesController < ApplicationController
  # def index
    # @stories = project.stories
    # render json: @stories.to_json
  # end
  #
  before_filter :iteration

  def new
    @last_story = iteration.stories.last
    render
  end

  def create
    params[:story][:after_id] = params[:story][:after_id].to_i
    @story = project.create_story(params[:story])
    if @story.id.blank?
      flash[:error] = "Could not save the story."
      render action: 'new'
    else
      flash[:success] = "Story has been created."
      redirect_to iterations_path
    end
  end

private

  def iteration
    @iteration ||= project.iterations(number: params[:iteration_id]).first
  end

end
