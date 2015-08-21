require 'rails_helper'

RSpec.shared_examples "a webhook payload" do
  its(:kind) { is_expected.to be_a(String) }
  its(:project_version) { is_expected.to be_a(Integer) }
  its(:guid) { is_expected.to match(/\d+_\d+/) }
  its(:message) { is_expected.to be_a(String) }
  its(:highlight) { is_expected.to be_a(String) }
  its(:occurred_at) { is_expected.to be_a(DateTime) }
  its(:changes) { is_expected.to be_a(Array) }
  its(:primary_resources) { is_expected.to be_a(Array) }
  its(:project) { is_expected.to be_a(Hash) }
  its(:performed_by) { is_expected.to be_a(Hash) }
end

RSpec.describe WebhookPayload do

  describe 'story move activity' do
    let(:payload_file) { File.read(Rails.root.join('spec/fixtures/activity_payloads/story_move_activity.json')) }
    let(:payload) { JSON.parse(payload_file) }
    let(:obj) { described_class.new(payload) }

    subject { obj }

    its(:kind) { is_expected.to eql "story_move_activity" }
    its(:highlight) { is_expected.to eql "moved and scheduled" }

    it_behaves_like 'a webhook payload'
  end

  describe 'story delete activity' do
    let(:payload_file) { File.read(Rails.root.join('spec/fixtures/activity_payloads/story_delete_activity.json')) }
    let(:payload) { JSON.parse(payload_file) }
    let(:obj) { described_class.new(payload) }

    subject { obj }

    its(:kind) { is_expected.to eql "story_delete_activity" }
    its(:highlight) { is_expected.to eql "deleted" }

    it_behaves_like 'a webhook payload'
  end

  describe 'story create activity' do
    let(:payload_file) { File.read(Rails.root.join('spec/fixtures/activity_payloads/story_create_activity.json')) }
    let(:payload) { JSON.parse(payload_file) }
    let(:obj) { described_class.new(payload) }

    subject { obj }

    its(:kind) { is_expected.to eql "story_create_activity" }
    its(:highlight) { is_expected.to eql "added" }

    it_behaves_like 'a webhook payload'
  end

  describe 'story estimated activity' do
    let(:payload_file) { File.read(Rails.root.join('spec/fixtures/activity_payloads/story_estimated_activity.json')) }
    let(:payload) { JSON.parse(payload_file) }
    let(:obj) { described_class.new(payload) }

    subject { obj }

    its(:kind) { is_expected.to eql "story_update_activity" }
    its(:highlight) { is_expected.to eql "estimated" }

    it_behaves_like 'a webhook payload'
  end
end
