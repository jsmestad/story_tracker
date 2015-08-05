class DefectsController < ApplicationController
  before_filter :authenticate_user!
  after_action :verify_authorized

  # def index
    # @stories = Defect.submitted.all
    # authorize @stories
    # render
  # end

  def new
    @defect = DefectFormatter.new
    authorize @defect, :create?
    render
  end

  def create
    @defect = DefectFormatter.new(defect_params)
    authorize @defect, :create?
    @story = Story.create_from_formatter(current_user, @defect.as_params)

    if @story.persisted?
      flash[:success] = "Defect has been submitted for review."
      redirect_to iterations_path
    else
      flash[:error] = "Could not save the defect."
      render action: 'new'
    end
  end

  # def update
    # @story = Story.find(params[:id])
    # authorize @story
    # if handle_state_change(@story, story_update_params[:state])
      # flash[:success] = "Defect has been #{@story.state}."
    # else
      # flash[:notice] = "Cannot update defect."
    # end
    # redirect_to stories_path
  # end

private

  def handle_state_change(defect, change)
    case change
    when 'approve'
      defect.approve!
    when 'reject'
      defect.reject!
    else
      false
    end
  end

  def defect_update_params
    params.require(:defect).permit(:state)
  end

  def defect_params
    params.require(:defect).permit(:assumption, :actual, :workaround)
  end
end
