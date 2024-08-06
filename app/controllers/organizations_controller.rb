class OrganizationsController < ApplicationController
  skip_before_action :set_tenant, only: %i[new create index]

  def index; end

  def new
    @organization = Organization.new
  end

  def create
    @organization = Organization.new(organization_params)
    owner_role = LookUp.find_by(name: 'owner')
    if @organization.save
      subdomain = @organization.site
      host_with_subdomain = "#{subdomain}.localhost"
      port = 3000
      # Manually construct the URL with the subdomain using URI module
      url_with_subdomain = URI::HTTP.build(
        host: host_with_subdomain,
        port:,
        path: new_user_registration_path,
        query: { role_id: owner_role.id }.to_query
      ).to_s
      redirect_to url_with_subdomain
    else
      render :new
    end
  end

  private

  def organization_params
    params.require(:organization).permit(:name, :site)
  end
end
