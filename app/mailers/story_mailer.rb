class StoryMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.story_mailer.updated_story_notification.subject
  #
  def updated_story_notification(to, story, update)
    @body = update
    if ENV['BCC_EMAILS_TO'].present?
      mail to: to, bcc: ENV['BCC_EMAILS_TO']
    else
      mail to: to
    end
  end
end
