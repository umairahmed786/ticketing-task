# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # DELETE /resource/sign_out
  def destroy
    super do
      flash[:notice] = t('devise.sessions.signed_out')
      redirect_to root_url(subdomain: false) and return
    end
  end

  protected

  def after_sign_in_path_for(resource)
    case resource.role.name
    when 'owner'
      flash[:notice] = t('devise.sessions.signed_in')
      owners_path
    when 'general_user'
      flash[:notice] = t('devise.sessions.signed_in')
      user_index_path
    when 'admin'
      flash[:notice] = t('devise.sessions.signed_in')
      admins_path
    when 'project_manager'
      flash[:notice] = t('devise.sessions.signed_in')
      project_managers_path
    else
      super
    end
  end
end
