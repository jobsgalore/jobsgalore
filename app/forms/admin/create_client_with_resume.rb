# frozen_string_literal: true

class Admin::CreateClientWithResume
  include Virtus.model(strict: true)
  include ActiveModel::Model

  attribute :subject
  attribute :fullname
  attribute :email
  attribute :phone
  attribute :location_id
  attribute :location_name
  attribute :industry
  attribute :title
  attribute :description
  attribute :password
  attribute :resume
  attribute :flag

  def save
    self.flag = false
    self.password = phone.present? ? phone : email
    client = Client.find_by_email(email)
    if client.blank?
      self.flag = true
      client = Client.new(
        email: email,
        phone: phone,
        password: password,
        password_confirmation: password,
        location_id: location_id
      )
      client.full_name = fullname
      errors.merge!(client.errors) unless client.save
    end
    if errors.blank?
      self.resume = Resume.new(
        title: title,
        description: description,
        location_id: client.location_id,
        industry_id: industry,
        client: client
      )
      if resume.save
        if self.flag
          params = {
            name: client.firstname,
            email: email,
            password: password
          }
          OtherMailer.the_resume_has_posted(email, "RE: #{subject}", params).deliver_later
        end
      else
        errors.merge!(resume.errors)
      end
    end
    errors.blank?
  end
end
