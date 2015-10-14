require 'rails_helper'

RSpec.describe PivotalTracker::StoryService do
  let(:user_mock) { instance_double("User", connection: MockPivotalClient.new(api_token: '1233')) }

  let(:story_model) { double('Story') }

  describe '#pull' do
    let(:external_story) do
      OpenStruct.new(name: 'changed', description: 'bar', story_type: 'bug')
    end

    it 'changes attributes based on the PT story' do
      service_obj = described_class.new(story_model)
      allow(service_obj).to receive(:fetch).and_return(external_story)

      expect(story_model).to receive(:name=).with('changed')
      expect(story_model).to receive(:description=).with('bar')
      expect(story_model).to receive(:story_type=).with('bug')

      service_obj.pull
    end
  end

  describe '#push!' do
    let(:external_story) do
      OpenStruct.new(name: 'changed', description: 'fizzbuzz', story_type: 'bug', save: true)
    end

    it 'pushes attributes based on the local story' do
      service_obj = described_class.new(story_model)
      allow(service_obj).to receive(:fetch).and_return(external_story) # return mock PT story
      expect(service_obj).to receive(:_params_hash).and_return({name: 'foo', description: 'bar', story_type: 'chore'}).at_least(:once)

      expect(external_story).to receive(:name=).with('foo')
      expect(external_story).to receive(:description=).with('bar')
      expect(external_story).to receive(:story_type=).with('chore')

      allow(external_story).to receive(:save).and_return(true)
      expect(service_obj.push!).to eql(true)
    end
  end

  describe '#_connection' do
    it 'grabs the connection from the associated user' do
      allow(story_model).to receive(:user) { user_mock }
      service_obj = described_class.new(story_model)
      # expect(service_obj._connection).to be_a(TrackerProject)
      expect(service_obj._connection.api_token).to eql('1233')
    end
  end

  describe '#_params_hash' do
    it 'sets the params hash' do
      allow(story_model).to receive(:name) { 'foo' }
      allow(story_model).to receive(:description) { 'bar' }
      allow(story_model).to receive(:story_type) { 'baz' }
      allow(story_model).to receive(:after_id)

      service_obj = described_class.new(story_model)

      expect(service_obj._params_hash).to eql({
        name: 'foo', description: 'bar', story_type: 'baz'
      })
    end
  end

  describe '#create' do
    it 'returns the PT object on success' do
      story = FactoryGirl.build_stubbed(:story)
      allow(story).to receive(:update_attribute)

      service_obj = described_class.new(story)
      allow(service_obj).to receive(:_connection) { MockPivotalClient.new }

      expect(service_obj.create).to be_truthy
    end
  end

end
