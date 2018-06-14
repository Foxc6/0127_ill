# Preview all emails at http://localhost:3000/rails/mailers/alert_email
class AlertEmailPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/alert_email/invoice_email
  def invoice_email
    AlertEmail.invoice_email
  end

end
