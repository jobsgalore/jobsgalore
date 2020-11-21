# frozen_string_literal: true

class CreateJob
  include Virtus.model(strict: true)
  include ActiveModel::Model
  ATTR_NAMES={
      email: "Email",
      location_id: "City",
      title: "Title",
      full_name: "Full name",
      password: "Password",
      company_name: "Company name"}
  attribute :type, Symbol, default: :first_time
  attribute :full_name
  attribute :email
  attribute :location_id
  attribute :location_name
  attribute :title
  attribute :salarymin
  attribute :salarymax
  attribute :description
  attribute :password
  attribute :company_name


  validates_each  :full_name, :email, :password, :company_name, :location_id, :title   do |record, attr, value|
    if value.blank? &&
        (  record.first_time? ||
          (record.is_employer? && [:location_id, :title].include?(attr))||
          (record.is_applicant? && [:company_name, :location_id, :title].include?(attr)))
      record.errors.add(:base, "The field '#{ATTR_NAMES[attr]}' can't be blank")
    end
    if attr == :company_name && Company.find_by_name(value).present? && !record.is_employer?
      record.errors.add(:base, "This company name is already in use")
    end
    if attr == :email && Client.find_by_email(value).present? && record.first_time?
      record.errors.add(:base, "This email address is already in use")
    end
  end

  def is_applicant
    self.type = :is_applicant
  end

  def is_employer
    self.type = :is_employer
  end

  def save(user = nil)
      begin
        return false unless self.valid?
        result = nil
        Job.transaction do
          if first_time?
            result = save_first_time
          elsif is_applicant?
            result = save_job_from_applicant(user)
          else
            result = save_job_from_employer(user)
          end
        end
        result
      rescue
        Rails.logger.info("Error : #{$!}")
        false
      end
    end

  def is_applicant?
    type == :is_applicant
  end

  def is_employer?
    type == :is_employer
  end

  def first_time?
    type == :first_time
  end

  private

  def save_first_time
    company = create_company
    client = create_client(company)
    job = create_job(company:company, client: client)
    {company: company, client: client, job: job}
  end

  def save_job_from_applicant(user)
    company = create_company
    client = update_client(user, company)
    job = create_job(company:company, client:user)
    {company: company, client: client, job: job}
  end

  def save_job_from_employer(user)
    job = create_job(company: user&.company, client:user)
    {company: user.company, client: user, job: job}
  end

  def create_client(company)
    client = Client.new(
        email: email,
        character: TypeOfClient::EMPLOYER,
        password: password,
        password_confirmation: password,
        location_id: location_id,
        company: company
    )
    client.full_name = self.full_name
    client.save
    client
  end

  def update_client(user, company)
   user.update(character: TypeOfClient::EMPLOYER, company: company)
   user
  end

  def create_company
    Company.create(name: company_name, location_id: location_id, size: Size.first)
  end

  def create_job(company:, client:)
    Job.create(
        title: self.title,
        description: self.description,
        salarymin: self.salarymin,
        salarymax: self.salarymax,
        location_id: self.location_id,
        company_id: company.id,
        client_id: client.id
    )
  end

end
