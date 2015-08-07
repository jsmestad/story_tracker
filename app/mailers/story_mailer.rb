class StoryMailer < ApplicationMailer

  def submitted_story_notification(admins, story)
    admin_emails = admins.map(&:email_address)
    @story = story
    @story_name = story.name
    @story_created = story.created_at.strftime("%B %d %Y")
    mail to: admin_emails
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.story_mailer.updated_story_notification.subject
  #
  def updated_story_notification(to, story, update)
    @story_name = story.name
    @story_created = story.created_at.strftime("%B %d %Y")
    @story_updated = story.updated_at
    @body = update
    if ENV['BCC_EMAILS_TO'].present?
      mail to: to, bcc: ENV['BCC_EMAILS_TO']
    else
      mail to: to
    end
  end

  def deleted_story_notification(to, story, message=nil)
    @story_name = story.name
    @message = message
    @story_created = story.created_at.strftime("%B %d %Y")
    @story_updated = story.updated_at
    if ENV['BCC_EMAILS_TO'].present?
      mail to: to, bcc: ENV['BCC_EMAILS_TO']
    else
      mail to: to
    end
  end
end
