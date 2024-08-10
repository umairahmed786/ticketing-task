# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  protected

  def after_resetting_password_path_for(resource)
    case resource.role.name
    when 'owner'
      flash[:notice] = t('devise.passwords.updated')
      owners_path
    when 'general_user'
      flash[:notice] = t('devise.passwords.updated')
      user_index_path
    when 'admin'
      flash[:notice] = t('devise.passwords.updated')
      admins_path
    when 'project_manager'
      flash[:notice] = t('devise.passwords.updated')
      project_managers_path
    else
      super
    end
  end
end
