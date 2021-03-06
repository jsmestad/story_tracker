require 'rails_helper'

RSpec.describe Story do
  let(:story) { FactoryGirl.create(:story, :with_user) }
  subject { story }

  it { is_expected.to belong_to(:user) }

  it { is_expected.to have_many(:activities).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:user) }

  describe '#story_type' do
    it { is_expected.to allow_value('bug').for(:story_type) }
    it { is_expected.to allow_value('feature').for(:story_type) }
    it { is_expected.to allow_value('chore').for(:story_type) }
    it { is_expected.to_not allow_value('release').for(:story_type) }
  end

  describe 'subscriptions' do
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

  describe 'states' do
    it { is_expected.to respond_to(:state) }

    describe ':submitted' do
      it 'is the initial state' do
        expect(subject.submitted?).to eql(true)
      end
    end

    describe ':approved' do
      it 'can be transitioned from :submitted' do
        expect(subject).to receive(:send_to_tracker!).and_return(true)
        expect { subject.approve }.to change(subject, :approved?).from(false).to(true)
      end

      it 'cannot be transitioned from :submitted if PT is unavailable' do
        expect(subject).to receive(:send_to_tracker!).and_return(false)
        expect { subject.approve }.to raise_error(AASM::InvalidTransition)
      end

      it 'cannot be transitioned from :rejected' do
        subject.state = :rejected
        expect { subject.approve }.to raise_error(AASM::InvalidTransition)
      end
    end

    describe ':rejected' do
      it 'can be transitioned from :submitted' do
        expect { subject.reject }.to change(subject, :rejected?).from(false).to(true)
      end
    end

    describe ':completed' do
      it 'can be transitioned from :approved' do
        subject.state = :approved
        expect { subject.complete }.to change(subject, :completed?).from(false).to(true)
      end

      it 'cannot be transitioned from :rejected' do
        subject.state = :submitted
        expect { subject.complete }.to raise_error(AASM::InvalidTransition)
      end

      it 'cannot be transitioned from :rejected' do
        subject.state = :rejected
        expect { subject.complete }.to raise_error(AASM::InvalidTransition)
      end
    end

    describe '#additional_description' do
      let(:existing_story) { FactoryGirl.build_stubbed(:story, description: 'foo') }

      it 'appends to existing description' do
        existing_story.additional_description = 'bar'
        expect(existing_story.description).to eql("foo\nbar")
      end
    end

    describe '.in_flight scope' do
      it 'excludes rejected stories' do
        rejected_story = FactoryGirl.create(:story, :with_user, :as_rejected)
        approved_story = FactoryGirl.create(:story, :with_user, :as_approved)
        submitted_story = FactoryGirl.create(:story, :with_user)

        expect(described_class.in_flight.all).to include(approved_story, submitted_story)
        expect(described_class.in_flight.all).to_not include(rejected_story)
      end
    end
  end
end
