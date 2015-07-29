class TrackerProject
  attr_accessor :project_id, :api_token

  def initialize(project_id: nil, api_token: nil)
    self.api_token = api_token || ENV['PIVOTAL_TRACKER_API_TOKEN']
    self.project_id = project_id || ENV['DEFAULT_TRACKER_PROJECT']
  end

  def is_properly_configured?
    project.account_id
    true
  rescue TrackerApi::Error
    false
  end

  def method_missing(method, *args, &block)
    project.send(method, *args, &block)
  end

private

  def project
    @project ||= connection.project(project_id)
  end

  def connection
    @connection ||= begin
                      TrackerApi::Client.new(token: self.api_token)
                    end
  end
end
