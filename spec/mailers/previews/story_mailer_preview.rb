# Preview all emails at http://localhost:3000/rails/mailers/story_mailer
class StoryMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/story_mailer/updated_story_notification
  def updated_story_notification
    StoryMailer.updated_story_notification
  end

end
