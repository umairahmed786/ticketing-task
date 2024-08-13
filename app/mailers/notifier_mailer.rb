class NotifierMailer < ApplicationMailer
  default from: 'info@7vals.com' 
  def issue_mark_as_resoleved(title, recipient)
    mail(
      to: recipient,
      subject: 'Issue Update',
      body: "#{title} issue is updated"

    )
  end
end
