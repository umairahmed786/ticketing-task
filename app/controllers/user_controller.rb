class UserController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource class: 'User'
  before_action :find_user_by_invitation_token, only: [:edit]
  before_action :set_roles, only: %i[new create edit update edit_user_profile update_user_profile]

  def index
    @users = case current_user.role.name
             when 'owner'
               User.where.not(id: current_user.id)
             when 'admin'
               User.where(role_id: Role.where(name: %w[project_manager general_user]).ids)
             when 'project_manager'
               User.where(role_id: Role.where(name: 'general_user').ids)
             end
    @users = @users
             .select('users.*, COUNT(DISTINCT projects.id) AS projects_count')
             .left_joins(:projects)
             .group('users.id')
             .paginate(page: params[:page], per_page: 1)
             .to_a
  end

  def show
    @user = User.find_by(id: params[:id])
  end

  def new
  end

  def create
    @user.mark_as_confirmed
    if @user.save
      UserMailer.invite_email(@user).deliver_now
      redirect_to dashboards_path, notice: t('user.invite_email')
    else
      flash.now[:alert] = @user.errors.full_messages.join(', ')
      render :new
    end
  end

  def edit_user_profile
    @user = User.find_by(id: params[:id])
  end

  def update_user_profile
    @user = User.find_by(id: params[:id])
    @user.skip_reconfirmation!
    if @user.update(user_params)
      changes = @user.previous_changes.slice(:name, :email, :role_id)
      UserMailer.data_updated_email(@user, changes).deliver_now
      flash[:notice] = t('user_updated')
      redirect_to user_index_path
    else
      flash.now[:alert] = @user.errors.full_messages.join(', ')
      render :edit_user_profile
    end
  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: params[:id])
    @user.skip_reconfirmation!
    if @user.update(user_params)
      flash[:notice] = t('devise.registrations.updated')
      redirect_to user_path(current_user)
    else
      flash.now[:alert] = @user.errors.full_messages.join(', ')
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to user_index_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role_id, :organization_id)
  end

  def set_roles
    case current_user.role.name
    when 'owner'
      @roles = Role.where.not(name: 'owner')
    when 'admin'
      @roles = Role.where.not(name: %w[owner admin])
    when 'project_manager'
      @roles = Role.where(name: 'general_user')
    end
  end

  def find_user_by_invitation_token
    @user = User.find_by(invitation_token: params[:invitation_token])
    sign_in(@user) if @user
  end
end
