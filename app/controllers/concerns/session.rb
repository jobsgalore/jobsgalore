module Session
  extend ActiveSupport::Concern

  def restore_workflow_object(arg)
    begin
      Workflow.find_by_session(arg)
    rescue
      Rails.logger.debug  "Error restore_workflow_object: #{$!}"
      nil
    end
  end

  def add_new_workflow(arg = {})
    arg[:session][:workflow] = SecureRandom.uuid
    Workflow.new(arg)
  end

  def workflow_link(arg)
    Rails.logger.debug  "-->> Link for class #{arg.class.to_s.to_sym}"
    case arg.class.to_s.to_sym
    when :ClientWorkflow
      routs = client_link(arg)
      Rails.logger.debug  "-->> Link to #{routs}"
      routs
    when :ResumeWorkflow
      routs = resume_link(arg)
      Rails.logger.debug  "-->> Link to #{routs}"
      routs
    when :JobWorkflow
      routs = job_link(arg)
      Rails.logger.debug  "-->> Link to #{routs}"
      routs
    when :Redirect
      routs = arg.route
      Rails.logger.debug  "-->> Link to #{routs}"
      routs
    else
      Rails.logger.debug  "-->> nil"
      nil
    end
  end

  def client_link(arg)
    switch = LazyHash.new(  new: ->{new_client_session_path},
                            not_company: ->{new_company_path})
    switch[arg.aasm.current_state]
  end

  def job_link(arg)
    switch = LazyHash.new(  new: ->{new_job_path},
                            not_client: ->{new_client_session_path},
                            not_company: ->{new_company_path},
                            not_persisted: ->{jobs_path},
                            final: ->{job_path(arg.job.id)})
    switch[arg.aasm.current_state]
  end

  def resume_link(arg)
    switch = LazyHash.new(  new: ->{new_resume_path},
                            not_client: ->{new_client_session_path},
                            not_persisted: ->{resumes_path},
                            final: ->{resume_path(arg.resume.id)})
     switch[arg.aasm.current_state]
  end
end