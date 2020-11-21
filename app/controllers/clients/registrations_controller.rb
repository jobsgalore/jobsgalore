# frozen_string_literal: true

class Clients::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  skip_before_action :verify_authenticity_token, only: [:create]

  # GET /resource/sign_up
  def new
    super do
      @client_wf = restore_workflow_object(session[:workflow])
      @client_wf ||= add_new_workflow(class: :ClientWorkflow, client: resource, session: session)
      @client_wf.update_state(client: resource) if @client_wf.class == Redirect
      @client_wf.save!(session[:workflow])
      # [ResumeWorkflow, JobWorkflow].include?(@client_wf.class) ? @flag = true : @flag = nil
    end
  end

  # POST /resource
  def create
    build_resource(sign_up_params)
    @client_wf = restore_workflow_object(session[:workflow])
    if @client_wf.present?
      if @client_wf.class == ResumeWorkflow
        resource.add_type(TypeOfClient::APPLICANT)
      elsif @client_wf.class == JobWorkflow
        resource.add_type(TypeOfClient::EMPLOYER)
      end
      resource.save
      @client_wf.update_state(client: resource)
      if resource.persisted?
        resource.skip_confirmation! if (@client_wf.class == Redirect) && Rails.env.production?
        if resource.active_for_authentication?
          set_flash_message! :notice, :signed_up
          sign_up(resource_name, resource)
          @client_wf&.save!(session[:workflow])
          respond_with resource, location: after_sign_up_path_for(resource)
        else
          @client_wf&.save!(session[:workflow])
          set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
          expire_data_after_sign_in!
          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end
      else
        @client_wf&.save!(session[:workflow])
        clean_up_passwords resource
        alert = resource.errors.full_messages.map {|msg| msg}.join(' ')
        @client_wf.try(:route?) ? redirect_to(@client_wf.route, alert: alert) : respond_with(resource)
      end
    else
      redirect_to new_client_registration_path, notice: 'Id session is null. Can you try again, please?'
    end
  end

  # GET /resource/editclient_wf = workflow
  def edit
    super
  end

  # PUT /resource
  def update
    super
  end

  # DELETE /resource
  def destroy
    super
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  def cancel
    super
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[attribute full_name])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    Rails.logger.debug("controller Clients::RegistrationsController.after_sign_up_path_for")
    patch = workflow_link(@client_wf)
    patch || super(resource)
  end

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(resource)
    Rails.logger.debug("controller Clients::RegistrationsController.after_inactive_sign_up_path_for")
    patch = workflow_link(@client_wf)
    patch || super(resource)
  end
end
