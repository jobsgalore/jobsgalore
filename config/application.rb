require_relative 'boot'
require_relative '../app/addon/prawn-styled-text/prawn-styled-text.rb'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Mango
  class Application < Rails::Application
    config.active_record.schema_format = :sql
    config.to_prepare do
      Devise::Mailer.layout "mailer"
      Devise::Mailer.helper :email
    end
    config.action_dispatch.default_headers = {
        'X-Frame-Options' => 'ALLOW-FROM https://vk.com/'
    }
    #config.public_file_server.headers = {
     #   'Cache-Control' => 'public, max-age = 604800',
    #    'Expires' => "#{1.year.from_now.to_formatted_s(:rfc822)}"
    #}
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    #config.exceptions_app = self.routes
    #config.action_dispatch.rescue_responses.merge!(
    #    'MyClass::FileNotFound' => :not_found
    #)

  end

end
