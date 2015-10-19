class StoriesController < ApplicationController
  before_filter :authenticate_user!
  after_action :verify_authorized

  respond_to :json, :html

  def index
    @stories = Story.submitted.all
    authorize @stories
    render
  end

  def search
    authorize :story, :search?
    if params[:q].present? and params[:q].length < 3
      flash[:notice] = 'Search term must be at least 3 characters.'
      redirect_to iterations_path
    else
      @stories = Story.approved.search(params[:q]).order('created_at DESC')
      respond_with @stories
    end
  end

  def show
    @story = Story.find_by_guid(params[:id])
    authorize @story
    respond_with @story
  end

  def new
    if params[:advanced]
      @story = AdvancedStoryFormatter.new
      authorize @story, :create?
      render :new_advanced
    else
      @story = StoryFormatter.new
      authorize @story, :create?
      render
    end
  end

  def create
    if params[:advanced]
      formatted_story = AdvancedStoryFormatter.new(story_params)
    else
      formatted_story = StoryFormatter.new(story_params)
    end
    authorize formatted_story, :create?
    @story = Story.create_from_formatter(current_user, formatted_story.as_params)
    if @story.persisted?
      admins = User.admin.where('email_address IS NOT NULL').all
      unless admins.empty?
        StoryMailer.submitted_story_notification(admins, @story).deliver_now
      end
      flash[:success] = "Story has been submitted for review."
      redirect_to iterations_path
    else
      flash[:error] = "Could not save the story."
      render action: 'new'
    end
  end

  def edit
    @story = Story.find_by_guid(params[:id])
    authorize @story, :update?
  end

  def update
    @story = Story.find_by_guid(params[:id])
    authorize @story
    if @story.update_attributes(story_update_params)
      flash[:success] = "Story revision has been submitted successfully."
    else
      flash[:notice] = "Cannot update story."
    end
    redirect_to account_path
  end

private

  def story_update_params
    params.require(:story).permit(:name, :additional_description, :comment)
  end

  def story_params
    if params[:advanced]
      params.require(:story).permit(:name, :body)
    else
      params.require(:story).permit(:stakeholder, :the_ask, :reasoning, :error_expectation, :confirmation_flow)
    end
  end
end
