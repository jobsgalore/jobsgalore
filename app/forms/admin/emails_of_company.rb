# frozen_string_literal: true

class Admin::EmailsOfCompany
  include Virtus.model(strict: true)
  include ActiveModel::Model

  attribute :uuid, Integer
  attribute :name, String
  attribute :size_id, Integer
  attribute :location, Location
  attribute :site
  attribute :logo_uid
  attribute :recrutmentagency
  attribute :description
  attribute :realy
  attribute :emails, Array
  attribute :industry_id, Integer

  def save; end

  def self.find_by_id(id)
    company = Company.includes(:location, :industry, :size).find_by_id(id)
    new(
      uuid: company.id,
      name: company.name,
      size_id: company.size&.id,
      location: company.location,
      site: company.site,
      logo_uid: company.logo_uid,
      recrutmentagency: company.recrutmentagency,
      description: company.description,
      realy: company.realy,
      emails: company.email_hr&.to_a,
      industry_id: company.industry&.id,
    )
  end

  def emails_to_grid
    if emails.present?
      emails.map do |email|
        res = { id: email.id,
                email: email.email,
                fio: email.fio,
                phone: email.phone,
                main: email.main,
                send_email: email.send_email,
                contact: email.contact }
        if email.location_id
          res[:location_id] = email.location_id
          res[:location_name] = Location.find_by_id(email.location_id).name
        end
        res
      end
    end
  end
end
