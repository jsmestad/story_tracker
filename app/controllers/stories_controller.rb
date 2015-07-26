class StoriesController < ApplicationController
  before_filter :authenticate_user!
  after_action :verify_authorized

  def new
    @story = StoryFormatter.new
    authorize @story, :create?
    render
  end

  def create
    formatted_story = StoryFormatter.new(story_params)
    authorize formatted_story, :create?
    @story = project.create_story(formatted_story.as_params)
    if @story.id.blank?
      flash[:error] = "Could not save the story."
      render action: 'new'
    else
      current_user.stories.create!(external_ref: @story.id)
      flash[:success] = "Story has been created with ID <a href='#{@story.url}'>##{@story.id}</a>."
      redirect_to iterations_path
    end
  end

private

  def story_params
    params.require(:story).permit(:stakeholder, :the_ask, :reasoning, :error_expectation, :confirmation_flow)
  end
end
