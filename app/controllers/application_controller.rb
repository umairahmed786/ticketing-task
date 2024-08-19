class ApplicationController < ActionController::Base
  set_current_tenant_through_filter
  before_action :set_tenant, :set_current_user
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do
    respond_to do |format|
      format.html { redirect_to dashboards_path, error: 'You are not authorized to access this page.' }
      format.json { render json: { error: 'You are not authorized to access this page.' }, status: :forbidden }
      format.js   { render json: { error: 'You are not authorized to access this page.' }, status: :forbidden }
    end
  end

  # Handle Record Not Found
  rescue_from ActiveRecord::RecordNotFound do
    respond_to do |format|
      format.html { redirect_to dashboards_path, error: 'The record you were looking for could not be found.' }
      format.json { render json: { error: 'The record you were looking for could not be found.' }, status: :not_found }
      format.js   { render json: { error: 'The record you were looking for could not be found.' }, status: :not_found }
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  private

  def set_tenant
    @organization = Organization.find_by!(subdomain: request.subdomain)
    set_current_tenant(@organization)
  end

  def set_current_user
    User.current = current_user
  end
end
