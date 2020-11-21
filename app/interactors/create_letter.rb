# frozen_string_literal: true

class CreateLetter
  include Interactor

  def call
    letter = context.params
    mailing = {}
    mailing[:offices] = recipients_from_client(letter['recipients']) + recipients_from_email(letter['recipients'])
    mailing[:message] = letter['message']
    mailing[:client_id] = context.client
    mailing[:resume_id] = letter['resume']
    mailing[:price] = letter['price'].to_f
    mailing[:type_letter] = letter['type']
    mailing[:cur] = letter['cur']
    new_letter = Mailing.new(mailing)
    context.fail! unless new_letter.save
    context.payment_url = new_letter.decorate.payment_url
  end

  private

  def ids_of_emails(recipients, type)
    recipients.values.map do |t|
      t['id'] if t['type_client'] == type
    end.compact
  end

  def recipients_from_email(recipients )
    EmailHr.where(id: ids_of_emails(recipients, 'email' )).includes(:location, :company).map do |recipient|
      {id: recipient.id,
       type_client: 'email',
       company: recipient.company.name,
       recipient: recipient.fio,
       main: recipient.main,
       email: recipient.email,
       area: recipient.location_id ? recipient.location.name : 'Australia' }
    end
  end

  def recipients_from_client(recipients )
    Client.where(id: ids_of_emails(recipients, 'client' )).includes(:location, :company).map do |recipient|
      {id: recipient.id,
       type_client: 'client',
       company: recipient.company.name,
       recipient: recipient.full_name,
       main: false,
       email: recipient.email,
       area:  recipient.location.name }
    end
  end

end
