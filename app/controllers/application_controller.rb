class ApplicationController < ActionController::Base
  set_current_tenant_through_filter
  before_action :set_tenant

  private

  def set_tenant
    @organization = Organization.find_by!(site: request.subdomain)
    set_current_tenant(@organization)
  end
end
