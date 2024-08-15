class DashboardsController < ApplicationController
  before_action :authenticate_user!
  def index
    @projects = @organization.projects
    @issues_count_by_state = Issue.group(:state).count
    if %w[owner admin].include? current_user.role.name
      @users_count_by_role = User.joins(:role).where(users: { organization_id: @organization.id })
                                 .group('roles.name').count
    end
    @projects_count_by_day = Project.where(projects: { organization_id: @organization.id })
                                    .group_by_day(:created_at, format: '%d %b %Y').count

    if %w[owner admin].include? current_user.role.name
      @users_count_by_day = User.where(users: { organization_id: @organization.id })
                                .group_by_day(:created_at, format: '%d %b %Y').count
    end

    @projects_count_by_day = Project.group_by_day(:created_at, format: '%b %d, %Y').count
    @issues_count_by_day = Issue.group_by_day(:created_at, format: '%b %d, %Y').count
    @comments_count_by_day = Comment.group_by_day(:created_at, format: '%b %d, %Y').count
  end
end
