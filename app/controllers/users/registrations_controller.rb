class Users::RegistrationsController < Devise::RegistrationsController
  skip_before_action :set_tenant, :set_current_user

  # GET /resource/sign_up
  def new
    @organization = Organization.new
    @user = User.new
    super
  end

  # POST /resource
  def create
    ActiveRecord::Base.transaction do
      organization = Organization.new(organization_params)
      if organization.save
        @user = User.new(sign_up_params.except(:organization).merge(role_id: Role.find_by(name: 'owner').id,
                                                                    organization_id: organization.id))

        if @user.save
          flash_message = t('devise.confirmations.send_instructions')
          build_url_with_subdomain = URI::HTTP.build(
            host: "#{organization.subdomain}.#{APP_HOST}",
            port: 3000,
            path: new_user_session_path,
            query: { flash: flash_message }.to_query
          ).to_s
          redirect_to build_url_with_subdomain
        else
          flash.now[:error] = @user.errors.full_messages.join(', ')
          raise ActiveRecord::Rollback
        end
      else
        flash.now[:error] = organization.errors.full_messages.join(', ')
        raise ActiveRecord::Rollback
      end
    end
    @user ||= User.new(sign_up_params.except(:organization))
    @organization ||= Organization.new(organization_params)
    render :new if performed? == false
  end

  protected

  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, organization: %i[name subdomain])
  end

  def organization_params
    params.require(:user).require(:organization).permit(:name, :subdomain)
  end
end
