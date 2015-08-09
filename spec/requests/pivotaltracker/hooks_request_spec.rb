require 'rails_helper'

RSpec.describe 'Pivotal Tracker webhooks' do
  let(:payload_file) { File.read(Rails.root.join('spec/fixtures/activity_payloads/story_move_activity.json')) }
  let(:payload) { JSON.parse(payload_file) }

  it 'requires a webhook payload' do
    post '/pivotal_tracker/callback', {}

    expect(response).to have_http_status(404)
  end

  it 'requires token param that matches the value of ENV["CALLBACK_TOKEN"]' do
    request_headers = {
      "Accept" => "application/json",
      "Content-Type" => "application/json"
    }
    post "/pivotal_tracker/callback", payload.to_json, request_headers

    expect(response).to have_http_status(404)
  end

  it 'handles a webhook payload' do
    user = FactoryGirl.create(:user, :with_email)
    FactoryGirl.create(:story, external_ref: 99432476, user: user)

    request_headers = {
      "Accept" => "application/json",
      "Content-Type" => "application/json"
    }
    post "/pivotal_tracker/callback?token=#{ENV['CALLBACK_TOKEN']}", payload.to_json, request_headers

    expect(response).to have_http_status(201)
  end

  it 'handles a webhook payload that does not match' do
    request_headers = {
      "Accept" => "application/json",
      "Content-Type" => "application/json"
    }
    post "/pivotal_tracker/callback?token=#{ENV['CALLBACK_TOKEN']}", payload.to_json, request_headers

    expect(response).to have_http_status(200)
  end

  describe 'delete' do

    let(:payload_file) { File.read(Rails.root.join('spec/fixtures/activity_payloads/story_delete_activity.json')) }

    it 'handles a delete call by removing the related story' do

      FactoryGirl.create(:full_story, external_ref: '98991768')
      FactoryGirl.create(:full_story, external_ref: '123')

      expect(Story.count).to eql(2)

      request_headers = {
        "Accept" => "application/json",
        "Content-Type" => "application/json"
      }
      post "/pivotal_tracker/callback?token=#{ENV['CALLBACK_TOKEN']}", payload.to_json, request_headers

      expect(response).to have_http_status(201)
      expect(Story.submitted.count).to eql(1)
      expect(Story.rejected.count).to eql(1)
      expect(Story.rejected.where(external_ref: nil).count).to eql(1)
    end

  end
end
