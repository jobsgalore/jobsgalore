class ApplicationController < ActionController::Base

  include Session
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from CanCan::AccessDenied, with: :render_404
  rescue_from ArgumentError, with: :render_404
  rescue_from ActiveRecord::ConnectionTimeoutError, with: :perform
  include ApplicationHelper
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :clear_session
  before_action :get_cookies

  private

  def perform
    puts "connectpool size #{ActiveRecord::Base.connection_pool.instance_eval {@size}}"
    puts "connections #{ActiveRecord::Base.connection_pool.instance_eval {@connections}.length}"
    puts "Threads = #{Thread.list.count}"
    Thread.list.each_with_index do |t, i|
      puts "---- trhead #{i}: #{t.inspect}"
      puts t.backtrace.take(5)
    end
    ActiveRecord::Base.connection_pool.clear_reloadable_connections!
  end

  def redirect_back_to_url
    full_url = URI(request.original_fullpath)
    Rails.logger.debug(full_url)
    query = full_url.query
    Rails.logger.debug(query)
  end

    def get_cookies
    Rails.logger.debug("#{request.env['HTTP_USER_AGENT']}  #{request.env['HTTP_ACCEPT_LANGUAGE']}")
    if @search.blank?
      if cookies[:query].present?
        begin
          @search = JSON.parse(cookies[:query])
        rescue
          Rails.logger.info("Error in cookies query")
          cookies[:query] = nil
          @search = { type: Objects::JOBS.code,value:"", location_id:'', location_name:"Australia", open:false}
        end
      else
        @search = { type: Objects::JOBS.code,value:"", location_id:'', location_name:"Australia", open:false}
      end
    end
  end

  def clear_session
    if session[:workflow]
      unless session[:workflow] &&
          %w(resumes experiment jobs companies clients locations registrations sessions omniauth_callbacks index industries).include?(controller_name) &&
          %w(linkedin google_oauth2 facebook new apply create search create_temporary create_job create_resume linkedin_resume_update file_to_html index).include?(action_name)
        Rails.logger.debug "---!!! Зачистили сессию controller_name #{controller_name} action_name #{action_name} !!!---"
        session[:workflow] = nil
      end
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys:[:location_id, :firstname, :lastname, :phone, :character, :photo, :photo, :gender, :birth])
  end

  # In ApplicationController
  def current_ability
    @current_ability ||= Ability.new(current_client)
  end

  def current_company
    if current_client&.resp?
      if current_client.company.nil?
        client = add_new_workflow(
          class: :ClientWorkflow,
          client: current_client,
          session: session
        )
        client.save!(session[:workflow])
        redirect_to workflow_link(client), notice: 'Please, enter information about your company.'
        nil
      else
        current_client.company
      end
    end
  end

  def render_404
    @main = Main.call(query:@search)
    render "errors/error_404", status: :not_found, formats: :html
  end

  Draper.configure do |config|
    config.default_controller = ApplicationController
  end

  def current_client
    super&.decorate
  end

  private

  def sm?
    browser.device.tablet?
  end

  def xs?
    browser.device.mobile?
  end

  def md?
    !(browser.device.mobile? || browser.device.tablet?)
  end

  def i_frame_app
    if params["vk_app_id"].present?
      cookies[:iframe] = true
    end
  end

  def i_frame_app_first
    params["vk_app_id"].present?
  end

  def i_frame_app?
    cookies[:iframe] || false
  end
end
