class Admin::ClientWithResumeController < ApplicationController
  load_and_authorize_resource :create_client_with_resume
  def new
    @client_with_resume = Admin::CreateClientWithResume.new
  end

  def create
    @client_with_resume = Admin::CreateClientWithResume.new(client_with_resume_params)
    if @client_with_resume.save
      if @client_with_resume.flag
        text_notice = <<~STR
        Hello #{@client_with_resume.resume.client.firstname},
  
        The resume has posted.
  
        Your login: #{@client_with_resume.email}
        Your password: #{@client_with_resume.password}
  
        Please, tell your friends about us.
        Thank you in advance!
        STR
      else
        text_notice = "The resume has posted."
      end
      redirect_to resume_url(@client_with_resume.resume), notice: text_notice
    else
      render :new
    end
  end

  protected

  def client_with_resume_params
    params.require(:admin_create_client_with_resume).permit(  :fullname,
                                                              :email, :phone,
                                                              :password,  :location_id,
                                                              :industry,
                                                              :location_name, :subject,
                                                              :title, :description)
    end
end