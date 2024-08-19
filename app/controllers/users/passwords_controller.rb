# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  before_action :authenticate_user!

  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      flash[:notice] = t('devise.passwords.send_instructions')
      respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name))
    else
      handle_errors(resource)
      respond_with(resource)
    end
  end

  protected

  def after_resetting_password_path_for(_resource)
    flash.now[:notice] = t('devise.passwords.updated')
    new_user_session_path
  end

  private

  def handle_errors(resource)
    flash.now[:error] = if resource.errors[:email].include?("can't be blank")
                          t('email_blank')
                        elsif resource.errors[:email] !~ /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
                          t('email_invalid')
                        elsif resource.errors[:email].include?('not found')
                          t('email_not_found')
                        end
  end

end
