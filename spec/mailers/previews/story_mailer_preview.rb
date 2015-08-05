# Preview all emails at http://localhost:3000/rails/mailers/story_mailer
class StoryMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/story_mailer/updated_story_notification
  def updated_story_notification
    @full_story = Story.first
    @full_story ||= FactoryGirl.create(:story, :with_user_and_email)
    message = "Justin Smestad started this feature"
    StoryMailer.updated_story_notification(@full_story.user.email_address, @full_story, message)
  end

  # Preview this email at http://localhost:3000/rails/mailers/story_mailer/deleted_story_notification
  def deleted_story_notification
    @full_story = Story.first
    @full_story ||= FactoryGirl.create(:story, :with_user_and_email)
    StoryMailer.deleted_story_notification(@full_story.user.email_address, @full_story, 'foobar')
  end


end
