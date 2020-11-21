#require 'sidekiq/web'

Rails.application.routes.default_url_options[:host] = ENV["HOST"]
Rails.application.routes.draw do
  #constraints CanAccessResque do
  #  mount Sidekiq::Web => '/sidekiq'
  #end
  get 'robot', to: 'index#robot'
  #get 'ads', to: 'index#ads'
  get 'sw', to: 'index#sw'
  get 'sitemap', to: 'index#sitemap'
  get 'sitemaps/:id', to: 'index#sitemaps', as: "sitemap_object"
  # get 'rss', to: 'index#rss'
  post 'file_to_html', to: 'index#file_to_html', as: "file_to_html"
  post 'clientforalert', to: 'clientforalert#create', as: "clientforalert"


  get 'clientforalert/unsubscribe/:id', to: 'clientforalert#unsubscribe', as: "unsubscribe_not_client"
  get 'client/unsubscribe/:id', to: 'clients#unsubscribe', as: "unsubscribe_client"

  devise_for  :clients, controllers:{ registrations: "clients/registrations",
                                      omniauthcallbacks: "clients/omniauthcallbacks",
                                      passwords: "clients/passwords",
                                      confirmations: "clients/confirmations",
                                      sessions: "clients/sessions",
                                      unlocks: "clients/unlocks",
                                      omniauth_callbacks: 'clients/omniauth_callbacks' }
  # devise_scope :client do
  #  get "/sign_up_employer" => "clients/registrations#sign_up_employer"
  #  post '/create_employer'=> "clients/registrations#create_employer"
  # end

  namespace :admin  do
    resources :client_with_resume,  only: [:new, :create]

    #companies
    resources :companies, only: [:edit, :update]
    get 'companies/:id/edit/get_company', to: "companies#get_company", as: "get_company"
    get 'companies/:id/edit/get_emails', to: "companies#get_emails", as: "get_emails"
    get 'companies/:id/edit/get_logo', to: "companies#get_logo", as: "get_logo"
  end

  # devise_for :clients
  #
  # mailing
  resources :mailing, only: [:destroy]
  get "letters/show", to: "mailing#show", as: "show_mailings"
  get "contacts_of_companies", to: "mailing#contacts_of_companies", as: "contacts_of_companies"
  get "contacts_of_companies/:name", to: "mailing#contacts_of_companies", as: "contacts_of_company"
  post "mailing", to: "mailing#create", as:  "mailing_create"
  get "contact_of_seekers", to: "mailing#contact_of_seekers", as: "contact_of_seekers"

  #ORDER
  get "orders/new/:id/:type", to: "new_order_visual#new", as: "new_order"
  resources :new_order_visual, only: [:create]

  resources :companies, only: [:new,:create, :show, :edit, :update, :destroy]
  get "companies/:id/:text", to: "companies#highlight_view", as: 'company_highlight_view'
  get "/edit_logo", to: 'companies#edit_logo'
  get "/settings_company", to: 'companies#settings_company'
  get '/company_jobs/:id', to:'companies#company_jobs', as: 'jobs_at_company'
  patch '/update_logo', to:"companies#update_logo", as: 'update_logo'


  resources :clients, only: [:create, :edit, :update]#, :destroy
  get '/team/new/', to: 'clients#new_member', as: 'team_new'
  post '/team/', to: 'clients#create_member', as: 'team_create'
  delete '/team/:id', to: 'clients#destroy_member', as: 'team_destroy'
  get "/edit_photo", to: 'clients#edit_photo'
  get '/profile/jobs', to: 'clients#jobs', as:  'jobs_root'
  get '/profile/resumes', to: 'clients#resumes', as:  'resumes_root'
  get "/settings", to: 'clients#settings'
  get "/team/", to: 'clients#team', as: 'team'
  get  '/team_change/:id', to: 'clients#change_type', as: 'change_type'
  patch '/update_photo', to:"clients#update_photo", as: 'update_photo'
  get '/linkedin_resume_update', to:"clients#linkedin_resume_update", as: 'linkedin_resume'
  post 'send_resume', to: 'clients#send_resume', as: 'send'
  post 'send_message', to: 'clients#send_message', as: 'send_msg'

  resources :experiment, only: [:create]
  resources :locations
  get '/search_locations/:query', to: 'locations#search'
  get 'in_location/:location/:object', to: 'locations#in_location', as: "local_object"

  # Dictionary
  get '/dictionary/:query', to: 'dictionaries#search'

  #payment
  get '/bill', to: 'payments#bill'
  get '/cancel_url', to: 'payments#cancel_url'
  resources :payments, only: [:create]

  #ADMINISTRATION CLIENTS
  get '/admin/customers/', to: 'clients#admin_index', as: 'admin_client'
  get '/admin/customers/edit_photo/:id', to: 'clients#admin_edit_photo', as: 'admin_client_edit_photo'
  get '/admin/customers/new', to: 'clients#admin_new', as: 'admin_client_new'
  get '/admin/customers/:id', to: 'clients#admin_show', as: 'admin_client_show'
  get '/admin/customers/:id/edit', to: 'clients#admin_edit', as: 'admin_client_edit'
  post '/admin/customers/', to: 'clients#admin_create', as: 'admin_client_create'
  delete '/admin/customers/:id', to: 'clients#admin_destroy', as: 'admin_client_destroy'
  get '/admin/', to: 'index#admin', as: "admin"

  #ADMINISTRATION COMPANIES
  get '/admin/companies/', to: 'companies#admin_index', as: 'admin_company_index'
  get '/admin/companies/edit_logo/:id', to: 'companies#admin_edit_logo', as: 'admin_company_edit_logo'
  get '/admin/companies/new', to: 'companies#admin_new', as: 'admin_company_new'
  get '/admin/companies/:id', to: 'companies#admin_show', as: 'admin_company_show'
  post '/admin/companies/', to: 'companies#admin_create', as: 'admin_company_create'
  delete '/admin/companies/:id', to: 'companies#admin_destroy', as: 'admin_company_destroy'

  #ADMINISTRATION  Team
  get '/admin/team/new/:id', to: 'companies#admin_new_member', as: 'admin_team_new'#+
  get '/admin/team/edit/:id', to: 'companies#admin_edit_member', as: 'admin_team_edit'#+
  patch '/admin/team/update/:id', to: 'companies#admin_update_member', as: 'admin_team_update'#+
  post '/admin/team/', to: 'companies#admin_create_member', as: 'admin_team_create'#+
  delete '/admin/team/:id', to: 'companies#admin_destroy_member', as: 'admin_team_destroy'#+
  get '/admin/team/:id', to: 'companies#client_in_company_index', as: 'admin_company_team'#+
  get '/admin/member_of_team/:id', to: 'companies#admin_show_member_of_team', as: 'admin_member_show'#+

  #ADMINISTRATION Jobs
  get '/admin/member/:id', to: 'companies#admin_index_job', as: 'admin_index_job'#+
  get '/admin/members/jobs/new/:id', to: 'companies#admin_new_job', as: 'admin_new_job'#+
  post '/admin/members/jobs/', to: 'companies#admin_create_job', as: 'admin_create_job'#+
  get '/admin/members/jobs/:id', to: 'companies#admin_show_job', as: 'admin_show_job'#+
  delete '/admin/members/jobs/:id', to: 'companies#admin_destroy_job', as: 'admin_destroy_job'#+

  #ADMINISTRATION JOBS
  post 'admin/jobs/extras/', to: 'jobs#admin_extras', as: 'admin_job_extras'
  get '/admin/jobs/', to: 'jobs#admin_index', as: 'admin_jobs'
  get '/admin/jobs/new', to: 'jobs#admin_new', as: 'admin_jobs_new'
  get '/admin/jobs/:id', to: 'jobs#admin_show', as: 'admin_jobs_show'
  get '/admin/jobs/:id/edit', to: 'jobs#admin_edit', as: 'admin_jobs_edit'
  post '/admin/jobs/', to: 'jobs#admin_create', as: 'admin_jobs_create'
  patch '/admin/jobs/:id', to: 'jobs#admin_update', as: 'admin_jobs_update'
  delete '/admin/jobs/:id', to: 'jobs#admin_destroy', as: 'admin_jobs_destroy'

  #ADMINISTRATION RESUMES
  post 'admin/resumes/extras/', to: 'resumes#admin_extras', as: 'admin_resume_extras'
  get '/admin/resumes/', to: 'resumes#admin_index', as: 'admin_resumes'
  get '/admin/resumes/new', to: 'resumes#admin_new', as: 'admin_resumes_new'
  get '/admin/resumes/:id', to: 'resumes#admin_show', as: 'admin_resumes_show'
  get '/admin/resumes/:id/edit', to: 'resumes#admin_edit', as: 'admin_resumes_edit'
  post '/admin/resumes/', to: 'resumes#admin_create', as: 'admin_resumes_create'
  patch '/admin/resumes/:id', to: 'resumes#admin_update', as: 'admin_resumes_update'
  delete '/admin/resumes/:id', to: 'resumes#admin_destroy', as: 'admin_resumes_destroy'

  #resources :responsibles
  #resources :sizes
  resources :industries, only:[:index]
  resources :properts, only:[:index, :new, :create, :edit, :update, :destroy]
  resources :payments, only:[:show,:index]

  resources :create_job, only:[ :create]
  resources :create_job, only:[ :new], as: 'job'
  resources :jobs, only:[ :show, :edit, :update, :destroy]
  get "job_options/:id", to: "jobs#options", as: 'job_options'
  get "jobs/:id/:text", to: "jobs#highlight_view", as: 'job_highlight_view'
  get "views_of_a_job/:id", to: "jobs#views", as: 'job_views'
  post "job_create/", to: "jobs#create_temporary", as: 'create_job'
  get "jobs/", to: "jobs#create_job", as: 'jobs'
  get "apply_job/:id", to: "jobs#apply", as: 'apply'
  get "prolong/:id", to: "jobs#prolong", as: 'prolong'
  get "similar_jobs/:id", to: "jobs#similar_jobs", as: 'similar_jobs'
  post "send_job/", to: "jobs#send_job", as: 'send_job'


  resources :resumes, only:[:new, :show, :edit, :update, :destroy]
  get "resumes/:id/:text", to: "resumes#highlight_view", as: 'resume_highlight_view'
  get "views_of_a_resume/:id", to: "resumes#views", as: 'resume_views'
  post "resume_create/", to: "resumes#create_temporary", as: 'create_resume'
  get "resumes/", to: "resumes#create_resume", as: 'resumes'
  get "message/:id", to: "resumes#message", as: 'msg'
  post "send_resume_to_me/", to: "resumes#send_resume", as: 'send_resume'

  get "/log_in/:id", to: "resumes#log_in", as: 'log_in'
  root  to: 'index#main'
  get "/terms_and_conditions", to: 'index#terms_and_conditions'
  get "/privacy", to: 'index#privacy'
  get "/about", to: 'index#about'
  get "/contact", to: 'index#contact'
  get "/advertising_terms_of_use", to: 'index#advertising_terms_of_use'
  post "/send", to: 'index#send_mail', as: "send_email"
  post "/send_customers", to: 'index#send_to_customers'
  get "/send_offer", to:'index#send_offer'
  get '/search', to: 'index#main_search'
  get '/by_category/:obj', to: 'index#by_category'
  get '/logo', to: 'index#logo'
  get '/jg', to: 'index#jg'
  get '/:category/:object', to: 'index#category_view'

  #errors
  get '*path', to: 'errors#error_404', via: :all

  #resources :educations
  #resources :languageresume
  #resources :experiences
  #resources :industryexperiences
  #resources :skillsjobs
  #resources :skillsresumes
  #resources :languages
  #resources :level

  def path_for_object(object)
    if object.job?
      job_path(object.id)
    else
      resume_path(object.id)
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
