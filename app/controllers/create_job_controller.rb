class CreateJobController < ApplicationController

  def new
    @job = CreateJob.new()
  end

  def create
    @job_service = CreateJobService.call(params: job_params, client: current_client)
    respond_to do |format|
      if @job_service.success?
        format.html { redirect_to new_order_path(@job_service.job, :job), notice:  @job_service.msg}
      else
        @job = @job_service.object
        format.html { render :new}
      end
    end
  end

  private

  def job_params
    params.require(:create_job).permit(:full_name, :email, :phone, :location_id, :location_name, :title, :salarymin, :salarymax, :description, :password, :company_name)
  end

end