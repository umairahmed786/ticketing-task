class ApplicationController < ActionController::Base
  set_current_tenant_through_filter
  before_action :set_tenant
  before_action :configure_permitted_parameters, if: :devise_controller?

  def routing_error
    raise ActionController::RoutingError, 'Page not found'
  end

  rescue_from CanCan::AccessDenied do
    respond_to do |format|
      format.html { redirect_to dashboards_path, alert: 'You are not authorized to access this page.' }
      format.json { render json: { error: 'You are not authorized to access this page.' }, status: :forbidden }
      format.js   { render json: { error: 'You are not authorized to access this page.' }, status: :forbidden }
    end
  end
  # Handle Routing Errors
  rescue_from ActionController::RoutingError do
    respond_to do |format|
      format.html { redirect_to dashboards_path, alert: 'Page not found.' }
      format.json { render json: { error: 'Page not found.' }, status: :not_found }
      format.js   { render json: { error: 'Page not found.' }, status: :not_found }
    end
  end
  # Handle Record Not Found
  rescue_from ActiveRecord::RecordNotFound do
    respond_to do |format|
      format.html { redirect_to dashboards_path, alert: 'The record you were looking for could not be found.' }
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
end
