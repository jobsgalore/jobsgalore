# Preview all emails at http://localhost:3000/rails/mailers/contact_us_mailer
class ContactUsMailerPreview < ActionMailer::Preview
  def send_mail
    ContactUsMailer.send_mail(firstname: "Timur", lastname:"Nichkov", email:"timur@mail.com", subject:"Выгодное предложение", message:"Добрый день! Мы хотели бы с вами сотрудничать", phone: "89503304534")
  end

  def send_to_customers
    ContactUsMailer.send_to_customers("mail@email.com")
  end

  def alert_of_change
    report = {}
    report[:new_resumes] = Resume.where("created_at >= :date", date: Time.now - 1.day).count
    report[:new_jobs] = Job.where("created_at >= :date", date: Time.now - 1.day).count
    report[:new_client] = Client.where("created_at >= :date and send_email = true", date: Time.now - 1.day).count
    report[:new_company] = Company.where("created_at >= :date and description is not null", date: Time.now - 1.day).count
    report[:new_pay_count] = Payment.where("created_at >= :date", date: Time.now - 1.day).count
    report[:new_pay_sum] = Payment.where("created_at >= :date and kindpay = 1", date: Time.now - 1.day).count * 10 + Payment.where("created_at >= :date and kindpay = 3", date: Time.now - 1.day).count * 5
    report[:new_viewed] = Viewed.where("created_at >= :date", date: Time.now - 1.day).count
    ContactUsMailer.alert_of_change(report)
  end
end
