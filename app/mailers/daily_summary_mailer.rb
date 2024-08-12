class DailySummaryMailer < ApplicationMailer
  def daily_summary(user, issues)
    @user = user
    @issues = issues
    mail(to: @user.email, subject: 'Daily Issue State Change Summary')
  end
end