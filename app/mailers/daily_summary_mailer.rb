class DailySummaryMailer < ApplicationMailer
  def daily_summary(user, issue)
    @user = user
    @issue = issue
    mail(to: @user.email, subject: 'Daily Summary Regarding Issue Changes')
  end
end
