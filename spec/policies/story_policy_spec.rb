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
    it "denies access if not an admin" do
      expect(subject).not_to permit(current_user)
      expect(subject).not_to permit(viewer)
    end

    it "allows access for an admin" do
      expect(subject).to permit(admin)
    end
  end
end
