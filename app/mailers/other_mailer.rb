class OtherMailer < ApplicationMailer
  layout false
  def the_resume_has_posted(email, subject, params)
    @params = params
    mail(from: PropertsHelper::EMAIL_FOR_CREATING_RESUMES,
         to: email,
         subject: subject,
         delivery_method_options: email_jobsgalore)
  end

  private

  def email_jobsgalore
    {address:'smtp.yandex.ru',
     port:25,
     domain:'yandex.ru',
     authentication:'plain',
     user_name: PropertsHelper::EMAIL_FOR_CREATING_RESUMES,
     password: PropertsHelper::PASSWORD_FOR_EMAIL_CREATING,
     enable_starttls_auto: true }
  end
end