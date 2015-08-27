class FollowsController < ApplicationController
  before_filter :authenticate_user!
  # after_action :verify_authorized

  respond_to :json

  def create
    @story = Story.find_by_guid(params[:story_id])
    current_user.follow(@story)
    head :created
  end

  def destroy
    @story = Story.find_by_guid(params[:story_id])
    current_user.stop_following(@story)
    head :ok
  end

end
