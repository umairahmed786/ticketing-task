namespace :daily_summary do
  desc "Send daily summary emails to users directly related to issue changes"
  task send_emails: :environment do
    organizations = Organization.all
    organizations.find_each do |organization|
      issue_history = organization.issue_histories.where('created_at >= ?', 1.day.ago)
      issue_history_ids = issue_history.pluck(:id)

      # Fetch users of the organization
      users = organization.users.where(role: Role.where(name: %w[admin owner]))
                          .or(organization.users.where(id: issue_history.map do |history|
                            [history.issue.project.project_manager_id, history.issue.assignee_id]
                          end.flatten.uniq))

      # Send daily summary email to each user
      users.each do |user|
        DailySummaryJob.perform_later(user.id, issue_history_ids)
      end
    end
  end
end
