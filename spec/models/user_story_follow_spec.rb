require 'rails_helper'

RSpec.describe 'User and Story follow support', type: :model do

  describe 'following a story' do
    let(:user) { FactoryGirl.create(:user) }
    let(:story) { FactoryGirl.create(:full_story) }

    it 'lets you follow a story' do
      expect {
        user.follow(story)
      }.to change { user.following?(story) }.from(false).to(true)
    end

    it 'lets you unfollow a story' do
      user.follow(story)
      expect {
        user.stop_following(story)
      }.to change { user.following?(story) }.from(true).to(false)
    end
  end
end
