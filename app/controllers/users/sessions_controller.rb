# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  before_action :set_flash_message_from_params, only: [:new]
  # DELETE /resource/sign_out
  def destroy
    super do
      flash.now[:notice] = t('devise.sessions.signed_out')
      redirect_to root_url(subdomain: false) and return
    end
  end

  protected

  def after_sign_in_path_for(_resource)
    flash.now[:notice] = t('devise.sessions.signed_in')
    dashboards_path
  end

  private

  def set_flash_message_from_params
    if params[:flash].present?
      flash[:notice] = params[:flash]
    end
  end
end
