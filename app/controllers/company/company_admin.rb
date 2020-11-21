module Admin

  def admin_edit_logo
  end

  # GET /companies
  # GET /companies.json
  def admin_index
    @companies = Company.all.includes(:location,:industry, :size, :client).order(:id).paginate(page: params[:page], per_page:21)
  end

  # GET /companies/1
  # GET /companies/1.json
  def admin_show
  end

  # GET /companies/new
  def admin_new
    @company = Company.new
  end

  # POST /companies
  # POST /companies.json
  def admin_create
    @company = Company.new(company_params)
    respond_to do |format|
      if @company.save
        format.html { redirect_to admin_company_show_path(@company), notice: 'Company was successfully created.' }
        format.json { render :show, status: :created, location: @company }
      else
        format.html { render :admin_new }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  def admin_company_jobs
    @objs = Company.find_by_id(params[:id]).job.order(updated_at: :desc).paginate(page: params[:page], per_page:25)
  end

  # DELETE /companies/1
  # DELETE /companies/1.json
  def admin_destroy
    @company.destroy
    respond_to do |format|
      format.html { redirect_to admin_company_url, notice: 'Company was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
end