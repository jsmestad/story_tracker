require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.filter_sensitive_data('<TRACKERAPITOKEN>') { ENV['PIVOTAL_TRACKER_API_TOKEN'] }
  c.filter_sensitive_data('<TRACKERPROJECT>') { ENV['DEFAULT_TRACKER_PROJECT'] }
end

