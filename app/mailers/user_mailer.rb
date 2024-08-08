# app/mailers/user_mailer.rb
class UserMailer < Devise::Mailer
  include Devise::Mailers::Helpers

  def confirmation_instructions(record, token, options = {})
    options[:subject] = "Confirmation instructions"
    options[:from] = 'your_email@example.com'
    options[:to] = record.email
    options[:template_path] = 'users/mailer'
    options[:template_name] = 'confirmation_instructions'

    # Generate URL with the subdomain
    subdomain = record.organization.subdomain
    options[:url_options] = { host: "#{subdomain}.#{APP_HOST}", port: 3000 }

    @token = token
    @resource = record
    mail(options) do |format|
      format.html { render 'users/mailer/confirmation_instructions' }
    end
  end

  def reset_password_instructions(record, token, options = {})
    options[:subject] = "Reset Password Instructions"
    options[:from] = 'your_email@example.com'
    options[:to] = record.email
    options[:template_path] = 'users/mailer'
    options[:template_name] = 'reset_password_instructions'

    # Generate URL with the subdomain
    subdomain = record.organization.subdomain
    options[:url_options] = { host: "#{subdomain}.#{APP_HOST}", port: 3000 }

    @token = token
    @resource = record
    mail(options) do |format|
      format.html { render 'users/mailer/reset_password_instructions' }
    end
  end
end
