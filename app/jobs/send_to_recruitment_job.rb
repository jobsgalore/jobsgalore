# frozen_string_literal: true

class SendToRecruitmentJob < ApplicationJob
  queue_as :default

  def perform(args={})
    resume = Resume.find_by_id(args[:id]).decorate
    message = <<-TEXT
    <p>Dear Recruiter,</p>
    <p>I am writing to enquire if you have any vacancies in your company. I enclose my CV for your information.</p>
    <p><a href="#{resume.url}?utm_campaign=invite_agency&utm_medium=email&utm_source=email">#{resume.title}</a></p>
    <p>I am a conscientious person who works hard and pays attention to detail. 
      I’m flexible, quick to pick up new skills and eager to learn from others. I also have lots of ideas and enthusiasm. 
      I’m keen to work for a company with a great reputation.</p>
    <p>I  would be delighted to discuss any possible vacancy with you at your convenience. 
      In case you do not have any suitable openings at the moment, 
      I would be grateful if you would keep my CV on file for any future possibilities.</p>
    <p>Thank you for taking the time to consider this application and 
      I look forward to hearing from you in the near future.</p>
     <p>Yours sincerely</p>
    TEXT
    letter = {
      client: resume.client,
      message: message
    }
    emails = []
    emails += EmailHr.select(
      'email_hrs.email'
    ).joins(:company).where(
      'email_hrs.send_email = true and companies.recrutmentagency = true and email_hrs.location_id = :location_id',
      location_id: resume.location_id
    ).pluck(:email)
    emails += Client.select(
        'clients.email'
    ).joins(:company).where(
        'clients.send_email = true and companies.recrutmentagency = true and clients.location_id = :location_id',
        location_id: resume.location_id
    ).pluck(:email)
    emails.push(PropertsHelper::ADMIN)
    emails.each do |recipient|
      MailingMailer.send_resume_to_company(letter, recipient, nil).deliver_later
    end
  end
end
