class DailySummaryJob < ApplicationJob
  queue_as :default

  def perform(user_id, issue_ids)
    user = User.find(user_id)
    issues = IssueHistory.where(id: issue_ids)
    DailySummaryMailer.daily_summary(user, issues).deliver_later
  end
end
