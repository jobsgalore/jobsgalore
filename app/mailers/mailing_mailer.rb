class MailingMailer < ApplicationMailer

  def send_resume_to_company(letter, email, pdf = nil)
    letter = OpenStruct.new(letter) if letter.class == Hash
    attachments["#{letter.client.full_name}.pdf"] = Base64.decode64(pdf) if pdf
    @letter, @email = letter, email
    @utm = create_utm(:invite_agency)
    mail(to:email, subject: 'New message from jobsgalore.eu')
  end
end