class StoriesController < ApplicationController
  before_filter :authenticate_user!
  after_action :verify_authorized

  def index
    @stories = Story.submitted.all
    authorize @stories
    render
  end

  def new
    @story = StoryFormatter.new
    authorize @story, :create?
    render
  end

  def create
    formatted_story = StoryFormatter.new(story_params)
    authorize formatted_story, :create?
    @story = Story.create_from_formatter(current_user, formatted_story.as_params)
    if @story.persisted?
      flash[:success] = "Story has been submitted for review."
      redirect_to iterations_path
    else
      flash[:error] = "Could not save the story."
      render action: 'new'
    end
  end

private

  def story_params
    params.require(:story).permit(:stakeholder, :the_ask, :reasoning, :error_expectation, :confirmation_flow)
  end
end
