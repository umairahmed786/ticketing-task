namespace :daily_summary do
  desc "Send daily summary emails to users directly related to issue changes"
  task send_emails: :environment do
    organizations = Organization.all
    organizations.find_each do |organization|
      issue_histories = organization.issue_histories.where.not(field_change_id: nil).where('issue_histories.created_at >= ?', 1.day.ago)
      issue_histories_ids = issue_histories.pluck(:id)

      # Fetch users of the organization
      project_users = issue_histories.joins(issue: :project).pluck('projects.project_manager_id', 'issues.assignee_id')
      users = organization.users.where(role: Role.where(name: %w[admin owner]))
                          .or(organization.users.where(id: project_users.flatten.uniq))

      # Send daily summary email to each user
      users.each do |user|
        DailySummaryJob.perform_later(user.id, issue_histories_ids)
      end
    end
  end
end
