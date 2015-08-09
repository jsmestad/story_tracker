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

  describe "submitted_story_notification" do
    let(:story) { FactoryGirl.create(:story, :with_user_and_email) }
    let(:admins) { FactoryGirl.create_list(:user, 2, :with_email, :admin) }
    let(:mail) { StoryMailer.submitted_story_notification(admins, story) }

    it "renders the headers" do
      expect(mail.subject).to eq("Story Submission Notice")
      expect(mail.to).to eq(admins.map(&:email_address))
      expect(mail.from).to eq(["foo@example.local"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("A new story has been submitted for review")
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

  describe "rejected_story_notification" do
    let(:story) { FactoryGirl.create(:story, :with_user_and_email) }
    let(:mail) { StoryMailer.rejected_story_notification(story.user.email_address, story) }

    it "renders the headers" do
      expect(mail.subject).to eq("Story Request Closed")
      expect(mail.to).to eq(["foo@example.com"])
      expect(mail.from).to eq(["foo@example.local"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Unfortunately your story request has been closed.")
    end
  end

end
