class UserDigestNotifier < ActionMailer::Base
  default from: "timetraqmail@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_digest_notifier.weekly_progress_report.subject
  #
  def weekly_progress_report(@user)
    @greeting = "Hi"
    
    user_email = @user.email

    mail to: user_email
  end
end
