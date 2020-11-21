class ResumesController < ApplicationController
  #before_action :authenticate_client!, only:[:edit, :update, :destroy]
  load_and_authorize_resource :resume
  before_action :authenticate_client!, only: [:message]
  before_action :set_resume, only: [:message,:views, :highlight_view, :show, :edit, :update, :destroy, :admin_show, :admin_edit, :admin_update, :admin_destroy]
  before_action :action_view, only:[:show, :highlight_view]
  #before_action :applicant!, only: :new


  # GET /resumes/1
  # GET /resumes/1.json
  def show
    @query = ''
  end

  def highlight_view
    @query = params[:text]
    render :show
  end

  def views
  end
  # GET /resumes/new
  def new
    Rails.logger.debug "<<<ResumesController NEW:>>>"
    resume_workflow = restore_workflow_object(session[:workflow])
    resume_workflow = add_new_workflow(class: :ResumeWorkflow, session: session) if resume_workflow.class != ResumeWorkflow
    @resume = resume_workflow.resume.decorate
    resume_workflow.save!(session[:workflow])
  end

  def create_temporary
    Rails.logger.debug "<<<ResumesController create_temporary:>>>"
    resume_workflow = restore_workflow_object(session[:workflow])
    resume_workflow&.update_state(resume:Resume.new(resume_params), client: current_client, not_linkedin: true)
    resume_workflow&.save!(session[:workflow])
    respond_to do |format|
      format.html { redirect_to workflow_link(resume_workflow)}
    end
  end
  # GET /resumes/1/edit
  def edit
  end

  def send_resume
    request = params.require(:send)
    puts request
    Email.create(email: request[:email])
    ResumesMailer.send_resume(request[:resume], request[:email], current_client).deliver_later
    head :ok
  end

  # POST /resumes
  # POST /resumes.json
  def create_resume
    Rails.logger.debug "<<<ResumesController create_resume:>>>"
    resume_workflow = restore_workflow_object(session[:workflow])
    @resume = resume_workflow.resume.decorate
    respond_to do |format|
      if @resume.save
        resume_workflow.save!(session[:workflow])
        #format.html {redirect_to workflow_link(resume_workflow) , notice: current_client ? 'The Resume was successfully created.' : flash[:notice]}
        format.html {redirect_to new_order_path(@resume.object, :resume), notice: current_client ? 'The Resume was successfully created.' : flash[:notice]}
      else
        format.html {render :new}
      end
    end
  end

  # PATCH/PUT /resumes/1
  # PATCH/PUT /resumes/1.json
  def update
    respond_to do |format|
      if @resume.update(resume_params)
        format.html { redirect_to resumes_root_path, notice: 'The CV was successfully updated.' }
        format.json { render :show, status: :ok, location: @resume }
      else
        format.html { render :edit }
        format.json { render json: @resume.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /resumes/1
  # DELETE /resumes/1.json
  def destroy
    @resume.destroy
    respond_to do |format|
      format.html { redirect_to resumes_root_path, notice: 'The CV was successfully destroyed.' }
    end
  end

  def admin_index
    @resumes = Resume.all.includes(:location,:client).order(:title).paginate(page: params[:page], per_page:21)
  end

  # GET /resumes/1
  # GET /resumes/1.json
  def admin_show
  end

  # GET /resumes/new
  def admin_new
      @resume = Resume.new
      @resume.location_id = 9509
  end

  # GET /resumes/1/edit
  def admin_edit
  end

  # POST /resumes
  # POST /resumes.json
  def admin_create
    param = resume_params
    industry = param[:ind]
    experience=param[:experience]
    param.delete(:ind)
    param.delete(:experience)
    param.delete(:location_name)
    @resume = Resume.new(param)
    if experience
      experience.each do |exp, exp1|
        if not(exp1[:position].empty?)
          @resume.experience.new(employer:exp1[:employer], location_id:exp1[:location_id], site:exp1[:site], titlejob:exp1[:position], datestart:exp1[:datestart], dateend:exp1[:dateend], description:exp1[:description] )
        end
      end
    end
    @resume.industryresume.new(industry:Industry.find_by_id(industry.to_i))
    respond_to do |format|
      if @resume.save
        format.html { redirect_to admin_resumes_show_path(@resume), notice: 'Resume was successfully created.' }
        format.json { render :admin_show, status: :created, location: @resume }
      else
        format.html { render :admin_new }
        format.json { render json: @resume.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /resumes/1
  # PATCH/PUT /resumes/1.json
  def admin_update
    param = resume_params
    if param[:location_id].nil? or param[:location_id].empty?
      param[:location_id]=find_location(param[:location_name])
    end
    industry = param[:ind]
    experience=param[:experience]
    param.delete(:ind)
    param.delete(:experience)
    param.delete(:location_name)
    @resume.experience.destroy_all
    if experience
      experience.each do |exp, exp1|
        if not(exp1[:position].empty?)
          if exp1[:location_id].nil? or exp1[:location_id].empty?
            exp1[:location_id]=find_location(exp1[:location_name])
          end
          @resume.experience.new(employer:exp1[:employer], location_id:exp1[:location_id], site:exp1[:site], titlejob:exp1[:position], datestart:exp1[:datestart], dateend:exp1[:dateend], description:exp1[:description] )
        end
      end
    end
    @resume.industryresume.destroy_all
    @resume.industryresume.new(industry:Industry.find_by_id(industry))
    respond_to do |format|
      if @resume.update(param)
        format.html { redirect_to admin_resumes_show_path(@resume), notice: 'Resume was successfully updated.' }
        format.json { render :admin_show, status: :ok, location: @resume }
      else
        format.html { render :admin_edit }
        format.json { render json: @resume.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /resumes/1
  # DELETE /resumes/1.json
  def admin_destroy
    @resume.destroy
    respond_to do |format|
      format.html { redirect_to admin_resumes_url, notice: 'Resume was successfully destroyed.' }
    end
  end

  def admin_extras
    param = resume_params
    @resume = Resume.find_by_id(param[:id]).decorate
    respond_to do |format|
      if @resume.extras(param[:option])
        format.html { redirect_to resume_path(@resume),  notice: 'Done' }
      else
        format.html { redirect_to resume_path(@resume),  notice: 'Error!!!.' }
      end
    end
  end

  def message
    resume_workflow = add_new_workflow(class: :Redirect, route: msg_url(@resume), session: session) #TODO Убрать
    resume_workflow.save!(session[:workflow]) #TODO Убрать
  end

  private

  def action_view
    unless current_client&.admin? or current_client == @resume.client
      ViewObjectJob.perform_later(
          @resume,
          client_id: current_client&.id,
          ip: request.remote_ip,
          lang: request.env['HTTP_ACCEPT_LANGUAGE'],
          agent: request.env['HTTP_USER_AGENT']
      )
    end
  end


  def set_resume
    @resume = Resume.find(params[:id]).decorate
  end

  def find_location(name)
    loc = Location.search(name).limit(1)
    if loc.nil? or loc.empty?
      ""
    else
      loc.first.id
    end
  end

    # Never trust parameters from the scary internet, only allow the white list through.
  def resume_params
    params.require(:resume).permit(:id, :title, :salary_form, :description , :client_id,:industry_id,
                                     :location_id, :location_name, :page, :option)
  end
end
