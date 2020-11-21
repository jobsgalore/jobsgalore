require 'company/company_wizard'
require 'company/company_admin'
class CompaniesController < ApplicationController
  include Wizard
  include Admin

  load_and_authorize_resource :company

  before_action :set_member, only: [:admin_destroy_member,
                                    :admin_show_member_of_team,
                                    :show_member_of_team,
                                    :admin_update_member,
                                    :admin_edit_member,
                                    :admin_index_job]
  before_action :set_jobs, only: [ :admin_new_job]
  before_action :set_company, only: [:highlight_view,
                                     :company_jobs,
                                     :show,
                                     :edit,
                                     :update,
                                     :destroy,
                                     :admin_show,
                                     :admin_edit,
                                     :admin_update,
                                     :admin_destroy,
                                     :admin_edit_logo]
  before_action :set_current_company, only:[:update_logo, :settings_company, :edit_logo]

  def settings_company
  end

  def edit_logo
  end

  def update_logo
    param = company_params
    respond_to do |format|
      if param.nil? or @company.update(param)
        format.html { redirect_to settings_company_path, notice: 'The logotype was successfully updated.' }
      else
        format.html { render :edit_logo }
      end
    end
  end
  # GET /companies
  # GET /companies.json
  def index
    @companies = Company.all.includes(:location,:industry, :size, :client).order(:name).paginate(page: params[:page], per_page:21)
  end

  # GET /companies/1
  # GET /companies/1.json
  def show;  end

  def highlight_view
    @query = params[:text]
  end

  # GET /companies/new
  def new
    client = restore_workflow_object(session[:workflow])
    render_404 if session[:workflow].nil? and current_client.nil?
    @company = Company.new(location: client.client.location ? client.client.location : Location.default ).decorate
  end

  # GET /companies/1/edit
  def edit
  end

  # POST /companies
  # POST /companies.json
  def create
    @company = Company.new(company_params)
    respond_to do |format|
      if @company.save
        client = restore_workflow_object(session[:workflow])
        client&.update_state(company: @company)
        patch = workflow_link(client)
        if current_client
          format.html { redirect_to patch ? patch : jobs_root_path, notice: 'Company was successfully created.' }
        else
          format.html { redirect_to patch ? patch : @company, notice: 'Company was successfully created.' }
        end
      else
        format.html { render :new }
      end
    end
  end

  def company_jobs
    @objs = Job.where(company_id: params[:id]).includes(:location).order(created_at: :desc).paginate(page: params[:page], per_page:25).decorate
  end

  # PATCH/PUT /companies/1
  # PATCH/PUT /companies/1.json
  def update
    respond_to do |format|
      if @company.update(company_params)
        #Rails.logger.info("----<< #{redirect_back_to_url} >>-----")
        format.html { redirect_to settings_company_path, notice: 'The Information about your company was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.json
  def destroy
    @company.destroy
    respond_to do |format|
      format.html { redirect_to companies_url, notice: 'Company was successfully destroyed.' }
    end
  end


  private


  # Use callbacks to share common setup or constraints between actions.
  def set_company
    @company = Company.find_by(id: params[:id]).decorate
  end

  def set_client
    @client = Client.find_by(id: params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def company_params
    if params[:company]
      params.require(:company).permit(:name, :size_id, :location_id, :site, :logo, :recrutmentagency, :description, :realy, :industry_id)
    end
  end

  def job_params
    params.require(:job).permit(:title, :location_id, :salarymin, :salarymax, :permanent, :casual, :temp, :contract, :fulltime, :parttime, :flextime, :remote, :description, :company_id, :education_id, :client_id, :career, :industry_id, :close, :page)
  end

  def set_jobs
    @client, @company = params[:id].split('x')
  end

  def set_current_company
    @company = current_company
  end

  def set_member
    a = params[:id].split('x')
    @client = Client.find(a[0])
    @company = a[1]
  end
end
