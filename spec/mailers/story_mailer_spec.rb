require "rails_helper"

RSpec.describe StoryMailer, type: :mailer do
  describe "updated_story_notification" do
    let(:payload) { FactoryGirl.create(:move_payload) }
    let(:story) { FactoryGirl.create(:story, :with_user_and_email) }
    let(:mail) { StoryMailer.updated_story_notification(story.user.email_address, story, payload.message) }

    it "renders the headers" do
      expect(mail.subject).to eq("Story Progress Update")
      expect(mail.to).to eq(["foo@example.com"])
      expect(mail.bcc).to eq(["justin@example.com"])
      expect(mail.from).to eq(["foo@example.local"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Good News. Your story request has been updated.")
    end
  end

  describe "deleted_story_notification" do
    let(:payload) { FactoryGirl.create(:delete_payload) }
    let(:story) { FactoryGirl.create(:story, :with_user_and_email) }
    let(:mail) { StoryMailer.deleted_story_notification(story.user.email_address, story, payload.message) }

    it "renders the headers" do
      expect(mail.subject).to eq("Story Request Closed")
      expect(mail.to).to eq(["foo@example.com"])
      expect(mail.bcc).to eq(["justin@example.com"])
      expect(mail.from).to eq(["foo@example.local"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Unfortunately your story request has been closed.")
    end
  end


end
