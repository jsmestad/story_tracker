class WebhookPayload

  attr_accessor :payload

  def initialize(payload)
    self.payload = payload
  end

  def kind
    payload['kind']
  end

  def guid
    payload['guid']
  end

  def project_version
    payload['project_version']
  end

  def message
    payload['message']
  end

  def highlight
    payload['highlight']
  end

  def changes
    payload['changes']
  end

  def primary_resources
    payload['primary_resources']
  end

  def project
    payload['project']
  end

  def performed_by
    payload['performed_by']
  end

  def occurred_at
    Time.at(payload['occurred_at']).to_datetime
  end

end
