class ApplicationController < ActionController::Base
  set_current_tenant_through_filter
  before_action :set_tenant, :set_current_user
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale

  rescue_from CanCan::AccessDenied do
    respond_to do |format|
      format.html { redirect_to dashboards_path, error: t(:access_denied, scope: :error) }
      format.json { render json: { error: t(:access_denied, scope: :error) }, status: :forbidden }
      format.js   { render json: { error: t(:access_denied, scope: :error) }, status: :forbidden }
    end
  end

  # Handle Record Not Found
  rescue_from ActiveRecord::RecordNotFound do
    respond_to do |format|
      format.html { redirect_to dashboards_path, error: t(:record_not_found, scope: :error) }
      format.json { render json: { error: t(:record_not_found, scope: :error) }, status: :not_found }
      format.js   { render json: { error: t(:record_not_found, scope: :error) }, status: :not_found }
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

  def default_url_options
    { locale: I18n.locale }
  end

  def set_locale
    I18n.locale = extract_locale || I18n.default_locale
  end

  def extract_locale
    parsed_locale = params[:locale]
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ?
      parsed_locale.to_sym :
      nil
  end
end
