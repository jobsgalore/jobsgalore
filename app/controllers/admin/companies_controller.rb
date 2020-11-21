class Admin::CompaniesController < ApplicationController
  before_action :set_company, only: [ :edit, :get_company, :get_emails, :get_logo]

  def edit; end

  def get_company
    render :get_company, formats: :json
  end

  def get_emails
    render :get_emails, formats: :json
  end

  def get_logo
    @logo = {logo_uid: @company.logo_uid ? Dragonfly.app.remote_url_for(@company.logo_uid) : nil }
    render :get_logo, formats: :json
  end

  def update
    company = Admin::UpdateCompany.call(params:company_params)
    render json: { message: "done" }, status: :ok  if company.success?
  end

  private
  def set_company
    @company = Admin::EmailsOfCompany.find_by_id(params[:id])
  end

  def company_params
    params.permit(:id, :action_executed, :data, data: [:img, :dup_id])
  end
end