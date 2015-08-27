require 'rails_helper'

RSpec.describe 'Story follow requests', type: :request do
  let!(:user) { FactoryGirl.create(:user, token: 'validtoken') }
  let!(:story) { FactoryGirl.create(:full_story) }

  let(:request_headers) do
    { "Accept" => "application/json", "Content-Type" => "application/json" }
  end

  let(:valid_token) {
    ActionController::HttpAuthentication::Token.encode_credentials('validtoken')
  }

  let(:authenticated_request_headers) do
     request_headers.merge('HTTP_AUTHORIZATION' => valid_token)
  end

  it 'requires authentication token' do
    post story_follow_path(story), {}, request_headers

    expect(response.status).to eql(401)
  end

  describe 'following a story' do
    it 'works when properly authenticated' do
      post story_follow_path(story), {}, authenticated_request_headers

      expect(response.status).to eql(201)
    end
  end

  describe 'unfollowing a story' do
    it 'works when properly authenticated' do
      delete story_follow_path(story), {}, authenticated_request_headers

      expect(response.status).to eql(200)
    end
  end

end

