class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project_managers, only: %i[new create edit update]
  load_and_authorize_resource find_by: :sequence_num

  def index
    @project_issues_count = {}
    @project_users_count = {}
    @project_admins = {}
    @project_project_managers = {}

    @projects = @projects.paginate(page: params[:page], per_page: 10)

    @projects.includes(:project_manager, :admin).find_each do |project|
      @project_issues_count[project.id] = project.issues.size
      @project_users_count[project.id] = project.users.size
      @project_admins[project.id] = project.admin&.name || t('not_assigned')
      @project_project_managers[project.id] = project.project_manager&.name || t('not_assigned')
    end
  end

  def new
  end

  def create
    @project.admin_id = current_user.id
    if @project.save
      redirect_to @project
    else
      render :new
    end
  end

  def show
    @organization_general_users = User.where.not(id: @project.users.pluck(:id) + [@project.project_manager_id, @project.admin_id].compact)
    @project_general_users = @project.users.select('id', 'name', 'email')
    @issues = @project.issues
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
      project_users = to_be_added_users.map { |id|
        {
          user_id: id,
          project_id: @project.id,
          organization_id: @organization.id,
          created_at: Time.current,
          updated_at: Time.current
        }
      }
      ProjectUser.insert_all(project_users)
    end
    redirect_to @project
  end

  def remove_user
    @project.users.destroy(params[:user_id])
    redirect_to @project
  end

  private

  def project_params
    params.require(:project).permit(:title, :description, :project_manager_id, :sequence_num)
  end

  def set_project_managers
    project_manager_role = Role.find_by(name: 'project_manager')
    @project_managers = current_tenant.users.where(role_id: project_manager_role.id) if project_manager_role
  end
end
