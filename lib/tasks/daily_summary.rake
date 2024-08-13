namespace :daily_summary do
  desc "Send daily summary emails to users directly related to issue changes"
  task send_emails: :environment do
    organizations = Organization.all
    organizations.find_each do |organization|
      issues = IssueHistory.where('created_at >= ? AND organization_id = ?', 1.day.ago, organization.id)
      issue_ids = issues.pluck(:id)
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
        DailySummaryJob.perform_later(user.id, issue_ids)
      end
    end
  end
end
