# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    @user = User.new
    @role_id = params[:role_id]
    super
  end

  # POST /resource
  def create
    @user = User.new(sign_up_params)
    @user.organization_id = params[:user][:organization_id]
    @user.role_id = params[:user][:role_id]
    if @user.save
      redirect_to new_user_session_path, 
                  notice: t('devise.confirmations.send_instructions')
    else
      flash[:alert] = @user.errors.full_messages.join(', ')
      render :new
    end
  end

  protected

  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role_id, :organization_id)
  end
end
