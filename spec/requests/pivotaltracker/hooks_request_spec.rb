require 'rails_helper'

RSpec.describe 'Pivotal Tracker webhooks' do
  let(:payload_file) { File.read(Rails.root.join('spec/fixtures/activity_payloads/story_move_activity.json')) }
  let(:payload) { JSON.parse(payload_file) }

  before do
    user = FactoryGirl.create(:user)
    FactoryGirl.create(:story, external_ref: 99432476, user: user)
  end

  it 'requires a webhook payload' do
    post '/pivotal_tracker/callback', {}

    expect(response).to have_http_status(404)
  end

  it 'handles a webhook payload' do
    request_headers = {
      "Accept" => "application/json",
      "Content-Type" => "application/json"
    }
    post '/pivotal_tracker/callback', payload.to_json, request_headers

    expect(response).to have_http_status(200)
  end
end
