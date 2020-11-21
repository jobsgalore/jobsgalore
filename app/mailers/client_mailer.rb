class ClientMailer < ApplicationMailer

  def send_invite_for_posting_resume(email)
    @utm = create_utm(:invite_for_posting_resume)
    mail(to:email, subject: "Do you want to get a dream job?")
  end
end