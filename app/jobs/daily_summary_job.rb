class DailySummaryJob < ApplicationJob
  queue_as :default

  def perform(user_id, issue_ids)
    return if issue_ids.blank?

    user = User.find(user_id)
    DailySummaryMailer.daily_summary(user, issue_ids).deliver_later
  end
end
