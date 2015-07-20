require 'rails_helper'

RSpec.describe WebhookPayload do
  let(:payload_file) { File.read(Rails.root.join('spec/fixtures/activity_payloads/story_move_activity.json')) }
  let(:payload) { JSON.parse(payload_file) }
  let(:obj) { described_class.new(payload) }

  subject { obj }

  its(:kind) { is_expected.to eql "story_move_activity" }
  its(:guid) { is_expected.to eql "1383802_45" }
  its(:project_version) { is_expected.to eql 45 }
  its(:message) { is_expected.to eql "Justin Smestad moved and scheduled this story before 'As a another customer, I want stuff'" }
  its(:highlight) { is_expected.to eql "moved and scheduled" }
  its(:occurred_at) { is_expected.to be_a(DateTime) }
end
