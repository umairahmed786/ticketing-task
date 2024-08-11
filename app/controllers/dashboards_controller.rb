class DashboardsController < ApplicationController
  before_action :authenticate_user!
  def index
    @projects = @organization.projects
    @issues_count_by_state = Issue.group(:state).count
    @users_count_by_role = User.joins(:role).where(users: { organization_id: @organization.id }).group('roles.name').count
    @projects_count_by_day = Project.where(projects: { organization_id: @organization.id }).group_by_day(:created_at, format: '%d %b %Y').count
    @users_count_by_day = User.where(users: { organization_id: @organization.id }).group_by_day(:created_at, format: '%d %b %Y').count

    @projects_count_by_week = Project.group_by_week(:created_at, format: '%b %d, %Y').count
    @issues_count_by_week = Issue.group_by_week(:created_at, format: '%b %d, %Y').count
    @comments_count_by_week = Comment.group_by_week(:created_at, format: '%b %d, %Y').count

    @combined_counts_by_week = {
      'Projects' => @projects_count_by_week,
      'Issues' => @issues_count_by_week,
      'Comments' => @comments_count_by_week
    }
  end
end
