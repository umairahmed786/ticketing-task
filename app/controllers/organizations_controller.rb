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
      url_with_subdomain = build_url_with_subdomain(owner_role_id, new_user_registration_path)
      redirect_to url_with_subdomain
    else
      flash.now[:alert] = generate_error_messages(@organization)
      render :new
    end
  end

  def render_login_form
    # This action renders the form where the user inputs their organization site
  end

  def login_existing
    if request.get?
      flash.now[:alert] = t('organization.subdomain_required')
      render :render_login_form and return
    else
      subdomain = params[:subdomain]

      # Validate the subdomain format
      if subdomain.blank?
        flash.now[:alert] = t('organization.subdomain_blank')
        render :render_login_form and return
      end
      if subdomain !~ /\A(?=.*[a-zA-Z])[a-zA-Z0-9]+\z/
        flash.now[:alert] = t('organization.subdomain_invalid')
        render :render_login_form and return
      end

      @organization = Organization.find_by(subdomain: params[:subdomain])
      owner_role_id = Role.find_by(name: 'owner').id
      if @organization.present?
        url_with_subdomain = build_url_with_subdomain(owner_role_id, new_user_session_path)
        redirect_to url_with_subdomain
      else
        flash.now[:alert] = t('organization.not_found')
        render :render_login_form
      end
    end
  end

  private

  def organization_params
    params.require(:organization).permit(:name, :subdomain)
  end

  def build_url_with_subdomain(owner_role_id, path)
    host_with_subdomain = "#{@organization.subdomain}.#{APP_HOST}"
    port = 3000
    # Manually construct the URL with the subdomain using URI module
    URI::HTTP.build(
      host: host_with_subdomain,
      port:,
      path: path,
      query: { role_id: owner_role_id }.to_query
    ).to_s
  end

  def generate_error_messages(organization)
    if organization.name.blank?
      t('organization.name_blank')
    elsif organization.subdomain.blank?
      t('organization.subdomain_blank')
    elsif organization.subdomain !~ /\A(?=.*[a-zA-Z])[a-zA-Z0-9]+\z/
      t('organization.subdomain_invalid')
    elsif Organization.find_by(subdomain: organization.subdomain).present?
      t('organization.subdomain_taken')
    elsif Organization.find_by(name: organization.name).present?
      t('organization.name_taken')
    else
      t('organization.unknown_error')
    end
  end
end
