class Clients::SessionsController < Devise::SessionsController
  before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
   def new
     super do
       client_wf = restore_workflow_object(session[:workflow]) #{|obj| obj.update({client:resource})}
       client_wf ||= add_new_workflow(class: :ClientWorkflow, client: resource, session: session)
       client_wf.save!(session[:workflow])
     end
   end

  #POST /resource/sign_in
   def create
     super do
       begin
         @client_wf = restore_workflow_object(session[:workflow])
         @client_wf.update_state({client:resource})
         @client_wf.save!(session[:workflow])
       rescue
         Rails.logger.debug("Error: #{$!}")
       end
     end
   end

  # DELETE /resource/sign_out
   def destroy
     super
   end

   protected
   def after_sign_in_path_for(resource)
     patch = workflow_link(@client_wf)
     patch ? patch : super(resource)
   end

  # If you have extra params to permit, append them to the sanitizer.
   def configure_sign_in_params
     devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
   end

   def auth_options
     { scope: resource_name, recall: "#{controller_path}#new" }
   end
end
