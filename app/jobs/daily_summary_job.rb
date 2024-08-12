class DailySummaryJob < ApplicationJob
  queue_as :default

  def perform
    organizations = Organization.all
    organizations.find_each do |organization|
      issues = IssueHistory.where('created_at >= ? AND organization_id = ?', 1.day.ago, organization.id)
      # Fetch admins of the organization
      admins = User.where(organization_id: organization.id, role: 'admin')
      # Fetch the owner of the organization
      owner = User.where(organization_id: organization.id, role: 'owner').first
      # Fetch project managers and assignees of the issues
      project_managers_and_assignees = issues.map do |issue_history|
        issue = issue_history.issue
        [issue.project.project_manager, issue.assignee]
      end.flatten.compact.uniq
      # Combine all users
      users = (admins + [owner] + project_managers_and_assignees).compact.uniq
      # Send daily summary email to each user
      users.each do |user|
        DailySummaryMailer.daily_summary(user, issues).deliver_now
      end
    end
  end
end
