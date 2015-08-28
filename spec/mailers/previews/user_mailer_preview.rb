# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/daily_summary
  def daily_summary
    @user = FactoryGirl.build(:user)
    UserMailer.daily_summary(@user)
  end

  def daily_summary_with_content
    @user = FactoryGirl.create(:user, token: SecureRandom.uuid)
    @stories = FactoryGirl.create_list(:story, 3, :with_activity, user: @user)

    UserMailer.daily_summary(@user)
  end

end
