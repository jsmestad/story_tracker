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

  def pull
    if remote_story = fetch
      _param_keys.each do |field|
        @model.send(:"#{field}=", remote_story.send(:"#{field}"))
      end
    else
      @model
    end
  end

  def push!
    if remote_story = fetch
      _param_keys.each do |field|
        remote_story.send(:"#{field}=", _params_hash[field.to_sym])
      end
      remote_story.save
    else
      false #create # TODO should this create or fail?
    end
  end

  # def update
  # end

  # def destroy
  # end

  def _param_keys
    %w(name description story_type)
  end

  def _params_hash
    h = {}
    _param_keys.each do |key|
      h[key.to_sym] = @model.send(:"#{key}")
    end
    h.merge!(after_id: after_id) if @model.after_id.present?
    h
  end

  # TODO remove user info from this, have the key crafted here
  #
  def _connection
    if @model.user
      @model.user.connection
    else
      TrackerProject.new
    end
  end
end
