class NotifierMailer < ApplicationMailer
  default from: 'info@7vals.com' 
  def issue_mark_as_resoleved(recipient)
    mail(
      to: recipient,
      subject: 'Issue Update',
      body: 'Issue is updated'

    )
  end
end
