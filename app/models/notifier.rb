class Notifier < ActionMailer::Base
  def activation_instructions(user)
    subject       "Activation Instructions"
    from          "Wholebooks Notifier"
    recipients    user.email
    sent_on       Time.now
    body          :account_activation_url => register_url(user.perishable_token)
  end

  def activation_confirmation(user)
    subject       "Activation Complete"
    from          "Wholebooks Notifier"
    recipients    user.email
    sent_on       Time.now
    body          :root_url => root_url
  end

  def password_reset_instructions(user)
    subject       "Password Reset Instructions"
    from          "Wholebooks Notifier"
    recipients    user.email
    sent_on       Time.now
    body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token)
  end

  def mail_to_contractors(emails, user)
    @subject          = "Thank you for search contracts"
    @recipients       = emails
    @from             = 'no-reply@yourdomain.com'
    @sent_on          = Time.now
    @body["user"]     = user.name
  end

end
