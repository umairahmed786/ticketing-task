class DashboardsController < ApplicationController
  before_action :authenticate_user!
  def index
    @issues_count_by_state = Issue.group(:state).count
    @users_count_by_role = User.joins(:role).group('roles.name').count if current_user.owner? || current_user.admin?
    @projects_count_by_day = Project.group_by_day(:created_at, format: '%d %b %Y').count
    if current_user.owner? || current_user.admin?
      @users_count_by_day = User.group_by_day(:created_at, format: '%d %b %Y').count
    end

    @projects_count_by_day = Project.group_by_day(:created_at, format: '%b %d, %Y').count
    @issues_count_by_day = Issue.group_by_day(:created_at, format: '%b %d, %Y').count
    @comments_count_by_day = Comment.group_by_day(:created_at, format: '%b %d, %Y').count
  end
end
