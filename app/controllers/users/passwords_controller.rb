# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  protected

  def after_resetting_password_path_for(resource)
    flash[:notice] = t('devise.passwords.updated')
    new_user_session_path
  end
end
