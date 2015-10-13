class PivotalTracker::StoryService
  def initialize(model)
    @model = model # Story AR model
  end

  def create
    _connection.create_story(_params_hash)
  rescue TrackerApi::Error
    false
  end

  def fetch
    _connection.story(@model.external_ref)
  rescue TrackerApi::Error
    nil
  end

  # def update
  # end

  # def destroy
  # end
  #
  def _params_hash
    h = {
      name: @model.name,
      description: @model.description,
      story_type: @model.story_type
    }
    h.merge!(after_id: after_id) if @model.after_id.present?
    h
  end

  def _connection
    if @model.user
      @model.user.connection
    else
      TrackerProject.new
    end
    # @model.user.connection
  end
end
