# app/mailers/user_mailer.rb
class UserMailer < Devise::Mailer
  include Devise::Mailers::Helpers

  def confirmation_instructions(record, token, opts = {})
    opts[:subject] = "Confirmation instructions"
    opts[:from] = 'your_email@example.com'
    opts[:to] = record.email
    opts[:template_path] = 'users/mailer'
    opts[:template_name] = 'confirmation_instructions'

    # Generate URL with the subdomain
    subdomain = record.organization.site
    opts[:url_options] = { host: "#{subdomain}.localhost", port: 3000 }

    @token = token
    @resource = record
    mail(opts) do |format|
      format.html { render 'users/mailer/confirmation_instructions' }
    end
  end

  def reset_password_instructions(record, token, opts = {})
    opts[:subject] = "Reset Password Instructions"
    opts[:from] = 'your_email@example.com'
    opts[:to] = record.email
    opts[:template_path] = 'users/mailer'
    opts[:template_name] = 'reset_password_instructions'

    # Generate URL with the subdomain
    subdomain = record.organization.site
    opts[:url_options] = { host: "#{subdomain}.localhost", port: 3000 }

    @token = token
    @resource = record
    mail(opts) do |format|
      format.html { render 'users/mailer/reset_password_instructions' }
    end
  end
end
