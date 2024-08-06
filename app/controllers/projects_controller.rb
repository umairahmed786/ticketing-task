class ProjectsController < ApplicationController
  # load_and_authorize_resource
  def index
    @projects = Project.all
  end
  
  def new
    @project = Project.new
    @project_managers = get_project_managers
  end

  def create
    @project = Project.new(project_params)
    @project.save!

    if @project.save
      redirect_to @project
    else
      render :new
    end
  end

  def show
    @project = Project.find(params[:id])
  end

  def edit
    @project = Project.find(params[:id])
    @users = get_project_managers
  end

  def update
    @project = Project.find(params[:id])

    if @project.update(project_params)
      redirect_to @project
    else
      render :edit
    end
  end

  def destroy
    @project = Project.find(params[:id])

    @project.destroy
    redirect_to projects_path
  end

  private

  def project_params
    params.require(:project).permit(:title, :description, :project_manager_id, :admin_id)
  end

  def get_project_managers
    project_manager_id = LookUp.where(name: 'owner', category: 'role').select(:id)
    User.select(:id, :name).where(role_id: project_manager_id)
  end
end
