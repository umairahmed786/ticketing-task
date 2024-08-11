# app/mailers/custom_devise_mailer.rb
class CustomDeviseMailer < Devise::Mailer
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`

  def confirmation_instructions(record, token, opts = {})
    @token = token
    @organization = record.organization # Assuming the user belongs to an organization

    subdomain = @organization.site
    host_with_subdomain = "#{subdomain}.localhost"
    port = 3000

    # Manually construct the confirmation URL with the subdomain
    opts[:redirect_url] = URI::HTTP.build(
      host: host_with_subdomain,
      port:,
      path: confirmation_url(record, confirmation_token: @token)
    ).to_s

    super
  end
end
