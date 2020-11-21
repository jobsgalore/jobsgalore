# frozen_string_literal: true

class JobsController < ApplicationController
  load_and_authorize_resource :job, except: [:show, :highlight_view, :similar_jobs]
  before_action :authenticate_client!, only: %i[apply prolong]
  before_action :set_job, only: %i[options prolong apply views edit update destroy admin_edit admin_update admin_destroy]
  before_action :set_job_with_deleted, only: %i[highlight_view show admin_show similar_jobs]
  # before_action :action_view, only: %i[show highlight_view]
  # before_action :employer!, only: :new

  def show
    @query=''
  end

  def highlight_view
    @query = params[:text].split('/')
    render :show
  end

  def options
  end

  def similar_jobs
    jobs = @job.similar_vacancies.decorate.map do |job|
        {id: job.id,
         url: job_url(job),
         apply: apply_path(job),
         title: job.title,
         location: job.location.name,
         location_url: local_object_url(job.location, Objects::JOBS.code),
         salary: job.salary,
         description: job.description_text,
         company: job.company.name,
         company_url: company_url(job.company),
         company_logo: job.company.logo_url,
         posted_date: job.posted_date,
         highlight: job.highlight.present?,
         urgent: job.urgent.present?
        }
    end.to_json
    render json: jobs
  end

  def views;  end

  # GET /jobs/new
  def new
    session[:workflow] = nil
    job_workflow = add_new_workflow(class: :JobWorkflow, session: session)
    @job = job_workflow.job.decorate
    job_workflow.save!(session[:workflow])
  end

  # GET /jobs/1/edit
  def edit; end

  def prolong
    if @job.prolong
      respond_to do |format|
        format.html { redirect_to job_path(@job), notice: 'The job opportunity was successfully prolonged.' }
      end
    end
  end

  def create_temporary
    job_workflow = restore_workflow_object(session[:workflow])
    job_workflow&.update_state(job: Job.new(job_params), client: current_client)
    job_workflow&.save!(session[:workflow])
    respond_to do |format|
      format.html { redirect_to workflow_link(job_workflow) }
    end
  end

  # POST /jobs
  # POST /jobs.json
  def create_job
    job_workflow = restore_workflow_object(session[:workflow])
    @job = job_workflow.job.decorate
    respond_to do |format|
      if @job.save
        job_workflow.save!(session[:workflow])
        format.html { redirect_to workflow_link(job_workflow), notice: current_client ? 'The job opportunity was successfully created.' : flash[:notice] }
      else
        format.html { render :new }
      end
    end
  end

  def apply
    if @job.apply && !@job.send_email? && !i_frame_app?
      unless current_client&.admin?
        @job.add_responded(client_id: current_client&.id, ip: request.remote_ip, lang: request.env['HTTP_ACCEPT_LANGUAGE'], agent: request.env['HTTP_USER_AGENT'])
      end
      redirect_to @job.apply, status: 307
    elsif @job.apply && !@job.send_email? && i_frame_app?
      @url = current_client&.resume&.count > 0 ? contacts_of_companies_url : new_resume_url
      render 'jobs/apply_iframe'
    else
      render 'jobs/apply'
    end
  end

  def send_job
    request = params.require(:send)
    Email.create(email: request[:email])
    JobsMailer.send_job(request[:job], request[:email]).deliver_later
    head :ok
  end

  # PATCH/PUT /jobs/1
  # PATCH/PUT /jobs/1.json
  def update
    respond_to do |format|
      if @job.update(job_params)
        format.html { redirect_to jobs_root_path, notice: 'The job opportunity was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /jobs/1
  # DELETE /jobs/1.json
  def destroy
    @job.destroy
    respond_to do |format|
      format.html { redirect_to jobs_root_path, notice: 'The job opportunity was successfully destroyed.' }
    end
  end

  def admin_index
    @not_id = Industryjob.all.map(&:job_id) if @not_id.nil?
    @jobs = Job.where('id not in (?)', @not_id).includes(:location, :company, :client).order(:close).paginate(page: params[:page], per_page: 21)
  end

  # GET /jobs/1
  # GET /jobs/1.json
  def admin_show; end

  # GET /jobs/new
  def admin_new
    @job = Job.new
    @job.location_id = 9509
  end

  # GET /jobs/1/edit
  def admin_edit; end

  # POST /jobs
  # POST /jobs.json
  def admin_create
    param = job_params
    industry = param[:ind]
    param.delete(:ind)
    @job = Job.new(param)
    @job.client = current_client
    @job.industryjob.new(industry: Industry.find_by_id(industry))
    respond_to do |format|
      if @job.save
        format.html { redirect_to admin_jobs_show_path(@job), notice: 'The job opportunity was successfully created.' }
      else
        format.html { render :admin_new }
      end
    end
  end

  # PATCH/PUT /jobs/1
  # PATCH/PUT /jobs/1.json
  def admin_update
    param = job_params
    respond_to do |format|
      if @job.update(param)
        format.html { redirect_to admin_jobs_url, notice: 'The job opportunity was successfully updated.' }
      else
        format.html { render :admin_edit }
      end
    end
  end

  # DELETE /jobs/1
  # DELETE /jobs/1.json
  def admin_destroy
    @job.destroy
    respond_to do |format|
      format.html { redirect_to admin_jobs_url, notice: 'The job opportunity was successfully destroyed.' }
    end
  end

  def admin_extras
    param = job_params
    @job = Job.find_by_id(param[:id]).decorate
    respond_to do |format|
      if @job.extras(param[:option])
        format.html { redirect_to job_path(@job),  notice: 'Done' }
      else
        format.html { redirect_to job_path(@job),  notice: 'Error!!!.' }
      end
    end
  end

  private

  def action_view
    unless current_client&.admin? || (current_client == @job.client) || @job.deleted?
      ViewObjectJob.perform_later(
        @job,
        client_id: current_client&.id,
        ip: request.remote_ip,
        lang: request.env['HTTP_ACCEPT_LANGUAGE'],
        agent: request.env['HTTP_USER_AGENT']
      )
    end
  end


  def set_job
    @job = Job.find(params[:id]).decorate
  end

  def set_job_with_deleted
    @job = Job.find_by_id_with_deleted(params[:id]).decorate
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def job_params
    params.require(:job).permit(:id, :title, :location_id, :salarymin, :salarymax, :description, :company_id, :client_id, :industry_id, :close, :page, :option)
  end
end
