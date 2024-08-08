class ProjectsController < ApplicationController
  before_action :set_project_managers, only: %i[new create edit update] 
  load_and_authorize_resource

  def index
  end

  def new
  end

  def create
    @project = Project.new(project_params.merge(admin_id: current_user.id))
    if @project.save
      redirect_to @project
    else
      render :new
    end
  end

  def show
    @organization_general_users = User.where.not(id: @project.users.pluck(:id))
    @project_general_users_name = @project.users.pluck('name')
  end

  def edit
  end

  def update
    if @project.update(project_params)
      redirect_to @project
    else
      render :edit
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_path
  end

  def add_user
    to_be_added_users = params[:to_be_added_users].reject(&:blank?)
    if to_be_added_users.present?
      project_users = to_be_added_users.map { |user_id|
        {user_id: user_id, project_id: @project.id, created_at: Time.now, updated_at: Time.now}
      }
      ProjectUser.insert_all(project_users)
    end
    redirect_to @project

  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:title, :description, :project_manager_id)
  end

  def set_project_managers
    project_manager_role = Role.find_by(name: 'project_manager')
    @project_managers = current_tenant.users.where(role_id: project_manager_role.id) if project_manager_role
  end
end
