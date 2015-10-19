require 'rails_helper'

describe StoryPolicy do
  subject { described_class }

  let (:current_user) { FactoryGirl.build_stubbed :user, :regular_user }
  let (:viewer) { FactoryGirl.build_stubbed :user }
  let (:admin) { FactoryGirl.build_stubbed :user, :admin }

  permissions :index? do
    it "denies access if not an admin" do
      expect(subject).not_to permit(current_user)
      expect(subject).not_to permit(viewer)
    end

    it "allows access for an admin" do
      expect(subject).to permit(admin)
    end
  end

  permissions :search? do
    it "allows access for all authenticated users" do
      expect(subject).to permit(current_user)
      expect(subject).to permit(viewer)
      expect(subject).to permit(admin)
    end
  end

  permissions :show? do
    it "allows access for all authenticated users" do
      expect(subject).to permit(current_user)
      expect(subject).to permit(viewer)
      expect(subject).to permit(admin)
    end
  end

  permissions :create? do
    it "prevents create if not an admin" do
      expect(subject).not_to permit(viewer)
    end
    it "allows an regular user to create" do
      expect(subject).to permit(current_user)
    end
    it "allows an admin to create" do
      expect(subject).to permit(admin)
    end
  end

  permissions :update? do
    let(:my_submitted_story) { FactoryGirl.create(:full_story, user: current_user) }
    let(:not_my_submitted_story) { FactoryGirl.create(:full_story) }
    let(:my_approved_story) { FactoryGirl.create(:full_story, :as_approved, user: current_user) }
    let(:my_rejected_story) { FactoryGirl.create(:full_story, :as_rejected, user: current_user) }

    it 'allows access for regular users, if you wrote the story' do
      expect(subject).not_to permit(current_user) # missing story obj, fails
      expect(subject).to permit(current_user, my_submitted_story)
    end

    it 'rejects access to others stories or if story is outside the submitted state' do
      expect(subject).not_to permit(current_user, not_my_submitted_story)
      expect(subject).not_to permit(current_user, my_approved_story)
      expect(subject).not_to permit(current_user, my_rejected_story)
    end

    it "denies access if a viewer" do
      expect(subject).not_to permit(viewer)
    end

    it "allows access for an admin" do
      expect(subject).to permit(admin)
    end
  end
end
