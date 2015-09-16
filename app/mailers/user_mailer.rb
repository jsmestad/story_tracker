class UserMailer < ApplicationMailer
  layout 'user_mailer'

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.daily_summary.subject
  #
  def daily_summary(user)
    @name = user.name
    @date = DateTime.now.strftime('%B %d %Y')
    @submissions = user.stories.in_flight.all
    @follows = user.following_stories.all

    @watched = (@follows + @submissions).sort_by(&:name)

    mail to: user.email_address, subject: "Daily StoryTracker Summary for #{@date}"
  end
end
