require 'rails_helper'

RSpec.describe Story do
  it { is_expected.to belong_to(:user) }

  it { is_expected.to validate_presence_of(:user) }

  describe 'subscriptions' do
    subject(:story) { FactoryGirl.build(:story, :with_user) }

    it 'has a #is_subscribed? method to check subscription status' do
      expect {
        story.subscribe = false
      }.to change(story, :is_subscribed?).from(true).to(false)
    end

    it 'has a #subscribe! method that turns on the subscription' do
      story.subscribe = false
      expect {
        story.subscribe!
      }.to change(story, :subscribe).from(false).to(true)
    end

    it 'has an #unsubscribe! method that turns off the subscription' do
      story.subscribe = true
      expect {
        story.unsubscribe!
      }.to change(story, :subscribe).from(true).to(false)
    end
  end
end
