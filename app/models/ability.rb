class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= Client.new
    #Rails.logger.debug "#{user.id} #{user.firstname} #{user.lastname} #{user.character} #{user.email}"
    if user.admin?
      Rails.logger.debug "Cancan:: Admin"
      can :manage, :all
      #can :manage, Sidekiq
    elsif user.employer?
      Rails.logger.debug "Cancan:: Employer"
      ##############################################
      role_employer(user)
    elsif user.employee?
      Rails.logger.debug "Cancan:: Employee"
      #############################################
      role_employee(user)
    elsif user.applicant?
      Rails.logger.debug "Cancan:: Applicant"
      #############################################
      role_applicant(user)
    else
      Rails.logger.debug "Cancan:: Other"
      #############################################
      role_other
    end
  end

  def can?(action, subject, *extra_args)
    #Rails.logger.debug "Cancan:: action #{action}  | subject #{subject}"
    if subject.class < Draper::Decorator
      subject = subject.model
    end
    super(action, subject, extra_args)
  end


  def role_employer(user)
    view_profile_jobs
    view_profile_resumes
    manager_team(user)
    create_company
    edit_resume_jobs_base(user)
    base(user)
  end

  def role_employee(user)
    view_profile_jobs
    view_profile_resumes
    edit_profile(user)
    edit_resume_jobs_base(user)
    base(user)
  end

  def role_applicant(user)
    view_profile_resumes
    create_company
    edit_profile(user)
    edit_resume_jobs_base(user)
    base(user)
  end

  def role_other(user = nil)
    create_company
    base(user)
  end

  def manager_team(user)
    can [:jobs, :resumes, :settings, :team, :edit, :update, :destroy, :edit_photo, :send_message,  :send_resume, :linkedin_resume_update, :change_type, :destroy_member, :update_photo], Client do |client|
      (client == user) || (client.company.client.include?(user))
    end
    can [:new_member, :create_member], Client
    can [:settings_company, :edit_logo, :update_logo, :edit, :update, :destroy], Company do |company|
      company.client.include?(user)
    end
    can [:edit, :update, :destroy], Job do |job|
      job.company.client.include?(user)
    end
  end

  def view_profile_resumes
    can [:resumes], Client do |client|
      client == user
    end
  end

  def view_profile_jobs
    can [ :jobs], Client do |client|
      client == user
    end
  end

  def edit_profile(user)
    can [:edit, :update, :settings, :destroy, :edit_photo, :update_photo, :send_resume, :linkedin_resume_update, :send_message], Client do |client|
      client == user
    end
  end

  def create_company
    can [:new, :create], Company
  end

  def edit_resume_jobs_base(user)
    can [:edit, :update, :destroy, :views], Resume do |resume|
      resume.client_id == user.id
    end
    can [:edit, :update, :destroy, :views, :prolong], Job do |job|
      job.client == user
    end
  end

  def base(user = nil)
    can [:new, :create_temporary, :create_job, :apply ], Job
    can [ :prolong ], Job do |job|
      user == nil or user == job.client
    end
    can [:new, :create_temporary, :create_resume, :message, :send_resume], Resume
    can [:show, :company_jobs, :highlight_view], Company
    can [:show, :highlight_view], Resume
    can [:show, :highlight_view, :similar_jobs, :options, :send_job], Job
    can [:search, :in_location], Location
    can [:bill, :cancel_url, :create], Payment
    can [:index], Industry
  end

end
