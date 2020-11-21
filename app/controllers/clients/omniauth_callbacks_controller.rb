class Clients::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
   def linkedin
     workflow_omniauth('linkedin', 'LinkedIn')
   end

   def google_oauth2
     workflow_omniauth('google_oauth2', 'Google')
   end

   def facebook
     workflow_omniauth('facebook', 'Facebook')
   end

  # More info at:
  # https://github.com/plataformatec/devise#omniauth

  # GET|POST /resource/auth/twitter
   def passthru
     super
   end

  # GET|POST /users/auth/twitter/callback
   def failure
     super
   end

  # protected

  # The path used when OmniAuth fails
   def after_omniauth_failure_path_for(scope)
     super(scope)
   end

   def after_sign_in_path_for(resource)
       Rails.logger.debug "---Clients::OmniauthCallbacksController after_sign_in_path_for"
       patch = workflow_link(@workflow)
       patch ? patch : super(resource)
   end

  def workflow_omniauth(provider, name)
    Rails.logger.debug "<<<Clients::OmniauthCallbacksController #{provider}:>>>"
    @client,resume = Client.from_omniauth(request.env["omniauth.auth"])
    @workflow = restore_workflow_object(session[:workflow])
    @workflow&.update_state(client:@client)
    @workflow&.update_state(resume:resume, to_start: true)  if resume && @workflow.class == ResumeWorkflow && !@workflow.not_linkedin
    if @client.persisted?
      @workflow&.save!(session[:workflow])
      sign_in_and_redirect @client, event: :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, kind: name) if is_navigational_format?
    else
      session["devise.#{provider}_data"] = request.env["omniauth.auth"]
      redirect_to new_client_registration_url
    end
  end
end
