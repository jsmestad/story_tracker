class ApplicationMailer < ActionMailer::Base
  default from: ENV['NOTIFICATION_FROM_ADDRESS']
  layout 'mailer'
end
