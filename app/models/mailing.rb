class Mailing < ApplicationRecord
  include AASM
  belongs_to :client
  belongs_to :resume

  def self.price(ip)
    cur = Country.currency_by_country(ip)
    {min_price_resume: Product.find_by_name('Mailing_Resume_To_Company_Min_Price').price_by_currency(cur),
    min_price_message: Product.find_by_name('Mailing_Any_Ads_To_Company_Min_Price').price_by_currency(cur),
    per_email_resume: Product.find_by_name('Mailing_Resume_To_Company_One_Email_Price').price_by_currency(cur),
    per_email_message: Product.find_by_name('Mailing_Any_Ads_To_Company_One_Email_Price').price_by_currency(cur),
    cur: cur}
  end

  def to_h
    {id: id,
     recipients: offices,
     created_at: created_at.to_date,
     message: markdown_to_text(message, 300),
     amount: price,
     status: status
    }
  end


  aasm do
    state :expect_the_payment, initial: true
    state :approval
    state :finished

    event :pay do
      transitions from: :expect_the_payment, to: :approval
    end

    event :affirm, after: :sending_emails do
      transitions from: :approval, to: :finished
    end

  end


  def status
    res = {
        expect_the_payment: "Expect the payment",
        approval: "Pending approval",
        finished: "Sent"
    }
    res[self.aasm_state.to_sym]
  end

  def sending_emails
    if self.type_letter == 'resume to companies' || self.type_letter == 'ad to companies'
      Rails.logger.info("Send email from #{self.client.email}")
      pdf = Base64.encode64(resume.to_pdf) if resume.present?
      self.offices.each do |t|
        MailingMailer.send_resume_to_company(self, t["email"], pdf).deliver_now
      end
      MailingMailer.send_resume_to_company(self, PropertsHelper::ADMIN, pdf).deliver_now
    end
  end
end
