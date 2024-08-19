class NotifierMailer < ApplicationMailer
  default from: 'info@7vals.com' 
  def issue_mark_as_resolved(title, new_state, recipient)
    @title = title
    @new_state = new_state.humanize
    mail(
      to: recipient,
      subject: 'Issue Update',
      template_name: 'issue_mark_as_resolved' # This points to the HTML file you created
    )
  end
end
