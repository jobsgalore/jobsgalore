class ContactUsMailer < ApplicationMailer

  def send_mail(email)
    @email = email
    mail(to: PropertsHelper::ADMIN, subject: "Contact")
  end

  def send_to_customers(mail)
      mail(to:mail, subject: "New website of jobs. We offer to join.")
  end

  def alert_of_change(arg)
    @arg = arg
    mail(to: PropertsHelper::ADMIN, subject: "changes on JobsGalore")
  end
end
