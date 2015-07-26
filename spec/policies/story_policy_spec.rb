require 'rails_helper'

describe StoryPolicy do
  subject { described_class }

  let (:current_user) { FactoryGirl.build_stubbed :user, :regular_user }
  let (:viewer) { FactoryGirl.build_stubbed :user }
  let (:admin) { FactoryGirl.build_stubbed :user, :admin }

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

end
