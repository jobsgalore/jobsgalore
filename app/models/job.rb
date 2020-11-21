# frozen_string_literal: true
DELETED = 'DELETED'
class Job < ApplicationRecord

  SHELF_LIFE = 30
  #include PgSearch::Model
  serialize :preferences, Hash

  after_create_commit :send_email_after_add_job

  before_destroy :send_email_before_destroy
  before_destroy :clone_to_deleted_jobs
  before_save :date_close
  include Rails.application.routes.url_helpers
  belongs_to :client
  belongs_to :location
  belongs_to :company
  belongs_to :industry
  has_many :viewed, as: :doc, dependent: :destroy
  has_many :responded, as: :doc, dependent: :destroy

  validates :title, presence: true
  validates :company, presence: true
  validates :location, presence: true
  validates :client, presence: true

  attr_accessor :location_name
  attr_accessor :state

  def self.find_by_id_with_deleted(id)
    job = self.find_by_id(id) || DeletedJob.find_by_original_id(id)&.to_job
    return job if job.present?
    raise ActiveRecord::RecordNotFound
  end

  def full_keywords(count_keys = 1, min_length_word = 4)
    if title
      array_keywords = []
      array_keywords = title&.gsub(/[^[:word:]]/, ' ')&.downcase&.split(' ') * 5
      if description
        desc = HtmlToPlainText.plain_text(description)
        desc = Search.str_to_search(desc)&.squish
        array_keywords += desc&.gsub(/[^[:word:]]/, ' ')&.downcase&.split(' ')
      end
      array_keywords.compact!
      index_hash = {}
      array_keywords.each do |word|
        if word.length > min_length_word
          index_hash[word] ? index_hash[word] += 1 : index_hash[word] = 1
        end
      end
      array_keywords = []
      index_hash.each do |key, value|
        array_keywords << { key => value }
      end
      array_keywords.sort { |x, y| y.values[0] <=> x.values[0] }[0..count_keys - 1].map { |t| t.keys.first }
    end
  end

  def deleted?
    state == DELETED
  end

  def add_viewed(arg = {})
    unless Viewed.fit(arg)
      viewed.create!(arg)
      viewed_count ? self.viewed_count += 1 : self.viewed_count = 1
      save!
    end
  end


  def add_responded(arg = {})
    responded.create!(arg)
    save!
  end

  def post_at_twitter(arg)
    twitt = TwitterClient.new
    update(twitter: twitt.update("#{arg} \r\n #{job_url(self, host: PropertsHelper::HOST_NAME)}"))
  end

  def highlight_on
    self.highlight = Date.today
    save
    #turn_on_option('Highlight')
  end

  def urgent_on
    self.urgent = Date.today
    save
    #turn_on_option('Urgent')
  end

  def top_on
    self.top = Date.today
    save
    #turn_on_option('Top')
  end

  def highlight_off
    self.highlight = nil
    save
    #turn_off_option('Highlight')
  end

  def urgent_off
    self.urgent = nil
    save
    #turn_off_option('Urgent')
  end

  def top_off
    self.top = nil
    save
    #turn_off_option('Top')
  end

  def self.delete_jobs
    where('close<date(?)', Time.now).destroy_all
  end

  def self.today_jobs
    Job.where("date_trunc('day',created_at) = date(?)", Time.now)
  end

  def days_before_сlose
    @date_now ||= Time.now.to_date
    (dt_close - @date_now).to_i
  end

  def dt_close
    [close, urgent, top, highlight].compact.max
  end

  def can_prolong?
    days = days_before_сlose
    days <= 2 ? days : false
  end

  def prolong
    self.close = Time.now + 14.days
    Rails.logger.debug("Проведена пролонгация записи #{title} - #{id}")
    save
  end

  def emails
    return [client.email] if client.send_email
    any_emails_in_location = company.client.where(location_id: location_id, send_email: true).pluck(:email)
    return [any_emails_in_location] if any_emails_in_location.present?
    any_emails = company.client.where(send_email: true).pluck(:email)
    return [any_emails] if any_emails.present?
    not_registration_email = company.email_hr.select(:email, send_email: true).where(main: true).pluck(:email)
    return [not_registration_email] if not_registration_email.present?
    nil
  end

  def send_email?
    emails.present?
  end

  def salary
    @salary ||= calc_salary
  end

  def save
    self.industry = Industry.find_by_name('Other') if industry.nil?
    self.company = client.company if company.nil? && client.company
    super
  end

  def to_short_h
    { id: id, title: title, salarymin: salarymin, salarymax: salarymax, description: description, client_id: client_id, company_id: company_id, location_id: location_id, industry_id: industry_id }
  end

  def self.automatic_create(**job)
    old_company = true
    company = Company.find_by_names_or_name(job[:company])
    if company.nil?
      company = Company.create(name: job[:company], size: Size.first, location_id: job[:location], industry_id: job[:industry])
      old_company = false
    end
    company.job.where(title: job[:title], location_id: job[:location]).destroy_all if old_company
    user = company.client.first
    if user.blank?
      email = "#{job[:company].delete("<>{}#@!,.:*&()'`\"’").tr(' ', '_')}#{(0...8).map { rand(97..121).chr }.join}@email.com.au"
      puts email
      user = Client.new(firstname: job[:company], lastname: 'HR', email: email, location_id: job[:location], character: TypeOfClient::EMPLOYER, send_email: false, password: '11111111', password_confirmation: '11111111', company_id: company.id)
      user.skip_confirmation! if Rails.env.production?
      user.save!
    end
    Rails.logger.debug "Сохраняем #{job[:title]}  в #{job[:location]}"
    Job.create!(title: job[:title],
                location_id: job[:location],
                salarymin: job[:salary_min],
                salarymax: job[:salary_max],
                description: job[:description],
                company: company,
                client: user,
                sources: job[:link],
                apply: job[:apply])
  end

  def similar_vacancies
    self.class.search_for_send(value: self.full_keywords(3).join(' '), location: self.location_id, exclude: id)
  end

  protected

  def send_email_after_add_job
    if client.send_email
      JobsMailer.add_job(self).deliver_later
      # JobsMailer.add_job(self, true).deliver_later
    end
  end

  def send_email_before_destroy
    JobsMailer.remove_job(self).deliver_later if client.send_email
  end

  def clone_to_deleted_jobs
    DeletedJob.create(
      original_id: id,
      title: title,
      salarymin: salarymin,
      salarymax: salarymax,
      description: description,
      location_id: location_id,
      company_id: company_id,
      begin: created_at
    )
  end

  def turn_on_option(option)
    JobsMailer.turn_on_option(option, self).deliver_later if client.send_email
  end

  def turn_off_option(option)
    JobsMailer.turn_off_option(option, self).deliver_later if client.send_email
  end

  def date_close
    self.close = Date.today + SHELF_LIFE.days if close.nil?
  end

  def calc_salary
    if salarymax.blank? && !salarymin.blank?
      '$' + salarymin.to_i.to_s
    elsif !(salarymax.blank? && salarymin.blank?)
      '$' + salarymin.to_i.to_s + ' - ' + '$' + salarymax.to_i.to_s
    elsif !salarymax.blank? && salarymin.blank?
      '$' + salarymax.to_i.to_s
    else
      ''
    end
  end


  scope :search_for_send, lambda { |**arg|
    arg[:limit] ||=3
    text_query = []
    mode = "ARRAY['phrase', 'plain', 'none']"
    query = {}#{ date: Time.now - 1.days }
    if arg[:location]
      text_query << 'location_id = :location'
      query[:location] = arg[:location]
    end
    if arg[:exclude]
      text_query << 'id != :id'
      query[:id] = arg[:exclude]
    end
    #text_query << 'created_at >= :date'
    text_query << 'fts @@ to_tsquery(\'english\',:value)'
    query[:old_value] = arg[:value]
    query[:value] = Search.str_to_search(arg[:value]).split(' ').map { |t| t += ':*' }.join('|')
    text_query = text_query.join(' and ')
    select(
        :id,
        :title,
        :location_id,
        :salarymax,
        :salarymin,
        :description,
        :company_id,
        :created_at,
        :updated_at,
        :highlight,
        :top,
        :urgent,
        :client_id,
        :close,
        :industry_id,
        :viewed_count,
        "user_rank(fts, '#{query[:old_value]}', '#{query[:value]}', #{mode}) AS \"rank\""
    ).where(text_query, query).order('rank DESC').limit(arg[:limit])
  }

  scope :search, lambda { |query|
    query = query.to_h if query.class != Hash
    text_query = []
    text_query << 'urgent is not null' if query[:urgent].present? && query[:urgent] != 'false'
    flag = true


    if query[:location_id].present? &&  query[:location_name].present?
      text_query << 'location_id = :location_id'
      flag = false
    elsif query[:location_name].present?
    locations = Location.search((query[:location_name].split(' ').map { |t| t += ':*' }).join('|'))
      if locations.present?
        text_query << 'location_id in ' + locations.ids.to_s.sub('[', '(').sub(']', ')')
        flag = false
      end
    end

    if flag
      date =  if ENV['RAILS_ENV'] == 'development'
                Job.last.created_at - 2.weeks
              else
                1.weeks.ago
              end
      text_query << "created_at >= TO_DATE('#{date.to_date}', 'yyyy-mm-dd')"
      mode = "ARRAY['phrase', 'plain']"
      text_query << 'fts @@ plainto_tsquery(\'english\',:old_value)' if query[:old_value].present?
    else
      text_query << 'fts @@ to_tsquery(\'english\',:value)' if query[:value].present?
    end


    if query[:salary].present?
      query[:salary] = query[:salary].to_i
      text_query << '((salarymin>=:salary) or (salarymax >= :salary))'
    end
    mode ||= "ARRAY['phrase', 'plain', 'none']"
    text_query = text_query.join(' and ')
    Rails.logger.info('Query::' + text_query + query.to_s)
    Rails.logger.info('Mode query::' + mode + query.to_s)
    select(:id, :title, :location_id, :salarymax, :salarymin, :description, :company_id, :created_at, :updated_at, :highlight, :top, :urgent, :client_id, :close, :industry_id, :viewed_count, "user_rank(fts, '#{query[:old_value]}', '#{query[:value]}', #{mode}) AS \"rank\"").where(text_query, query)
  }
end
