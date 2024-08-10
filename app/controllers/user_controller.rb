class UserController < ApplicationController
  load_and_authorize_resource class: 'User'
  before_action :find_user_by_invitation_token, only: [:edit]
  after_action :after_update_path, only: [:update]

  def index; end

  def new
    case current_user.role.name
    when 'owner'
      @roles = Role.where.not(name: 'owner')
    when 'admin'
      @roles = Role.where.not(name: %w[owner admin])
    when 'project_manager'
      @roles = Role.where(name: 'general_user')
    end
  end

  def create
    @user.mark_as_confirmed
    if @user.save
      UserMailer.invite_email(@user).deliver_now
      redirect_to owners_path, notice: t('user.invite_email')
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:notice] = t('devise.registrations.updated')
      redirect_to after_update_path
    else
      flash[:alert] = @user.errors.full_messages.join(', ')
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :role_id, :organization_id)
  end

  def find_user_by_invitation_token
    @user = User.find_by(invitation_token: params[:invitation_token])
    sign_in(@user) if @user
  end

  def after_update_path
    flash[:notice] = t('devise.updated')
    new_user_session_path
  end
end
