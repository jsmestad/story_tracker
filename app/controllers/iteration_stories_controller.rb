class IterationStoriesController < ApplicationController
  before_filter :iteration
  before_filter :authenticate_user!
  after_action :verify_authorized

  def new
    @story = StoryFormatter.new
    authorize @story, :create?
    render
  end

  def create
    formatted_story = StoryFormatter.new(story_params)
    formatted_story.after_id = last_story.to_param
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

  def iteration
    @iteration ||= project.iterations(number: params[:iteration_id]).first
  end

  def story_params
    params.require(:story).permit(:stakeholder, :the_ask, :reasoning, :error_expectation, :confirmation_flow)
  end

  def last_story
    iteration.stories.last
  end

end
