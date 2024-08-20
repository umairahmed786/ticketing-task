class DailySummaryMailer < ApplicationMailer
  def daily_summary(user, issues_ids)
    @user = user
    @issue = IssueHistory.where(id: issues_ids)
    mail(to: @user.email, subject: 'Daily Summary Regarding Issue Changes')
  end
end
