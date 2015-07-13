class StoriesController < ApplicationController
  before_filter :authenticate_user!

  def new
    @story = StoryFormatter.new
    render
  end

  def create
    formatted_story = StoryFormatter.new(story_params)
    @story = project.create_story(formatted_story.as_params)
    if @story.id.blank?
      flash[:error] = "Could not save the story."
      render action: 'new'
    else
      flash[:success] = "Story has been created with ID <a href='#{@story.url}'>##{@story.id}</a>."
      redirect_to iterations_path
    end
  end

private

  def story_params
    params.require(:story).permit(:stakeholder, :the_ask, :reasoning, :after_id)
  end
end
