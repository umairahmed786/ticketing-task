class DashboardsController < ApplicationController
  before_action :authenticate_user!
  def index
    @projects = @organization.projects
  end
end
