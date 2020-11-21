module Wizard


  def client_in_company_index
    @id = params[:id]
    @clients = Company.find(@id).client.all.includes(:location).order(:firstname).paginate(page: params[:page], per_page:21)
  end

  def admin_index_job
    @jobs = @client.job.order(created_at: :desc).paginate(page: params[:page], per_page:21)
  end

  def admin_new_job
    @job = Job.new(client_id:@client, company_id:@company, location_id: Company.find_by_id(@company).location_id)
  end

  def admin_create_job
    param = job_params
    industry = param[:ind]
    param.delete(:ind)
    @job = Job.new(param)
    @job.industryjob.new(industry:Industry.find_by_id(industry))
    respond_to do |format|
      if @job.save
        format.html { redirect_to admin_index_job_path("#{@job.client.id}x#{@job.company.id}"), notice: 'Job was successfully created.' }
        format.json { render :admin_show, status: :created, location: @job }
      else
        format.html { render :admin_new_job }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  def admin_show_job
    @job = Job.find_by_id(params[:id])
  end

  def admin_destroy_job
    @job = Job.find_by_id(params[:id])
    client, company = @job.client.id, @job.company.id
    @job.destroy
    respond_to do |format|
      format.html { redirect_to admin_index_job_path("#{client}x#{company}"), notice: 'Job was successfully destroyed.' }
    end
  end

  def admin_new_member
    @client = Client.new
    @company = params[:id]
  end

  def admin_create_member
    @client = Client.new(client_params)
    @id = params.require(:id).permit(:id).to_h
    Rails.logger.debug @id[:id]
    respond_to do |format|
      if @client.save
        Responsible.create(client_id:@client.id, company_id:@id[:id])
        format.html { redirect_to admin_company_team_path(@id[:id]), notice: 'Client was successfully created.' }
      else
        format.html { redirect_to admin_team_new_path(@id[:id]) }
      end
    end
  end

  def admin_edit_member
  end

  def admin_update_member
    respond_to do |format|
      if @client.update(client_params)
        format.html { redirect_to admin_company_team_path(@company), notice: 'Done!' }
      else
        format.html { redirect_to admin_team_edit_path("#{@client.id}x#{@company}") }
      end
    end
  end



  def admin_destroy_member
    @client.destroy
    respond_to do |format|
      format.html { redirect_to admin_company_team_path(@company), notice: 'Done!' }
    end
  end

  def admin_show_member_of_team
  end

end