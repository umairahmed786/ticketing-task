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
