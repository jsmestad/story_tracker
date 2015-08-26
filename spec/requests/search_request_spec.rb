require 'rails_helper'

RSpec.describe 'Search requests', type: :request do
  let!(:user) { FactoryGirl.create(:user, token: 'validtoken') }

  let(:request_headers) do
    { "Accept" => "application/json", "Content-Type" => "application/json" }
  end

  let(:invalid_token) { ActionController::HttpAuthentication::Token.encode_credentials('invalid_token') }

  it 'requires authentication token' do
    get search_stories_path, {q: 'foo'}, request_headers

    expect(response.status).to eql(401)
  end

  it 'requires authentication that is valid' do
    get search_stories_path, {q: 'foo'}, request_headers.merge('HTTP_AUTHORIZATION' => invalid_token)

    expect(response.status).to eql(401)
  end

  context 'when authenticated' do
    let(:valid_token) {
      ActionController::HttpAuthentication::Token.encode_credentials('validtoken')
    }

    it 'responds to requests' do
      get search_stories_path, {q: 'foo'}, request_headers.merge('HTTP_AUTHORIZATION' => valid_token)

      expect(response.status).to eql(200)
      expect(json_response).to include('data')
      expect(json_response['data']).to be_an_empty(Array)
    end
  end
end
