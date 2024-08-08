class UserController < ApplicationController
  load_and_authorize_resource
  def index; end

  def new
    @roles = Role.where.not(name: 'owner')
  end

  def create
    @user.mark_as_confirmed
    if @user.save
      UserMailer.invite_email(@user).deliver_later
      redirect_to owners_path, notice: t('user.invite_email')
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :role_id, :organization_id)
  end
end
