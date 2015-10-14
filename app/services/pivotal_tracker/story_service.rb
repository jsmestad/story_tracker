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
      _read_only_param_keys.each do |field|
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

  # def destroy
  # end

  # Keys to use in all operations #push and #pull
  #
  # @see #_read_only_param_keys
  def _param_keys
    %w(name description story_type)
  end

  # Additional keys to only use during #pull operation.
  #
  # @see #_param_keys
  def _read_only_param_keys
    _param_keys + %w(estimate)
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
