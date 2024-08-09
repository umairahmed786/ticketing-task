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
    if resource.role.name == 'owner'
      flash[:notice] = t('devise.sessions.signed_in')
      owners_path
    else
      super
    end
  end
end
