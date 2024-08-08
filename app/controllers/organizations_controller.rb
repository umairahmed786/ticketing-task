class OrganizationsController < ApplicationController
  skip_before_action :set_tenant

  def index; end

  def new
    @organization = Organization.new
  end

  def create
    @organization = Organization.new(organization_params)
    owner_role_id = Role.find_by(name: 'owner').id
    if @organization.save
      subdomain = @organization.subdomain
      host_with_subdomain = "#{subdomain}.#{APP_HOST}"
      port = 3000
      # Manually construct the URL with the subdomain using URI module
      url_with_subdomain = URI::HTTP.build(
        host: host_with_subdomain,
        port:,
        path: new_user_registration_path,
        query: { role_id: owner_role_id }.to_query
      ).to_s
      redirect_to url_with_subdomain
    else
      flash[:alert] = @organization.errors.full_messages.join(', ')
      render :new
    end
  end

  def login
    # This action renders the form where the user inputs their organization site
  end

  def process_login
    @organization = Organization.find_by(subdomain: params[:subdomain])
    owner_role_id = Role.find_by(name: 'owner').id
    if @organization.present?
      subdomain = @organization.subdomain
      host_with_subdomain = "#{subdomain}.#{APP_HOST}"
      port = 3000
      # Manually construct the URL with the subdomain using URI module
      url_with_subdomain = URI::HTTP.build(
        host: host_with_subdomain,
        port:,
        path: new_user_session_path, # Redirect to the login page
        query: { role_id: owner_role_id }.to_query
      ).to_s
      redirect_to url_with_subdomain
    else
      flash[:alert] = t('organization.not_found')
      render :login
    end
  end

  private

  def organization_params
    params.require(:organization).permit(:name, :subdomain)
  end
end
