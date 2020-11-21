class ResumesMailer < ApplicationMailer

  def add_resume(resume)
    @utm = create_utm(:new_resume)
    @resume = resume
    mail(to:@resume.client.email, subject: "Your resume was just posted on Jobs Galore!")
  end

  def remove_resume(email:, title:)
    @utm = "?"+create_utm(:remove_resume)
    @title = title
    mail(to: email, subject: "The resume was just removed")
  end

  def turn_on_option(option, resume)
    @utm = "?"+create_utm(:turn_on)
    @option, @resume = option, resume
    mail(to: resume.client.email, subject: "The option \"#{option}\" was turned on")
  end

  def turn_off_option(option, resume)
    @utm = "?"+create_utm(:turn_off)
    @option, @resume = option, resume
    mail(to: resume.client.email, subject: "The option \"#{option}\" was turned off")
  end

  def send_to_employer(resume, job, email, pdf, letter, copy = nil )
    @utm = create_utm(:letter_to_employer)
    @resume, @job, @letter = resume, job, letter
    client = (!copy ? email : PropertsHelper::ADMIN)
    attachments["#{@resume.client.full_name}.pdf"] = Base64.decode64(pdf) if pdf
    mail(to: client, subject: job.title)
  end

  def send_message(resume, letter, client, copy = nil)
    @utm = create_utm(:letter_to_applicant)
    @letter, @client, @resume = letter, client, resume
    client = (!copy ? @resume.client.email : PropertsHelper::ADMIN)
    mail(to:client, subject: @resume.title)
  end

  def send_resume(id, email, current_client)
    @utm = "?" + create_utm(:send_resume)
    @current_client = current_client
    @resume = Resume.find_by_id id
    attachments["#{@resume.client.full_name}.pdf"] if @current_client
    mail(to: email, subject: @resume.title)
  end

end