require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "daily_summary" do
    let!(:user) { FactoryGirl.create(:user, :with_email, token: SecureRandom.uuid) }
    let!(:stories) { FactoryGirl.create_list(:story, 3, :with_activity, user: user) }
    let(:mail) { UserMailer.daily_summary(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Daily StoryTracker Summary for #{Date.today.strftime('%B %d %Y')}")
      expect(mail.to).to eq([user.email_address])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("here is an update on all of your submissions as of")
    end

    it "only displays stories that are not rejected" do
      rejected_story = FactoryGirl.create(:story, :as_rejected, :with_activity, name: 'rejected story', user: user)
      expect(mail.body.encoded).to_not match("#{rejected_story.name}")
    end
  end

end
