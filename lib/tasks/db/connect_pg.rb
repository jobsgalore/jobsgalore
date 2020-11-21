require 'yaml'
require 'pg'
# require "#{Rails.root}/lib/tasks/db/connect_pg.rb"
class ConnectPg
  attr_accessor :connect
  def initialize
    if ENV['RAILS_ENV'] == 'production'
      config = YAML.load_file("#{Rails.root}/config/database.yml")[ENV['RAILS_ENV']]
      conf_app = YAML.load_file("#{Rails.root}/config/application.yml")[ENV['RAILS_ENV']]
      connect_string = nil
      if conf_app['DATABASE_URL']
        connect_string = conf_app['DATABASE_URL']
      else
        config['username'] = conf_app['MONGO_DATABASE_USER']
        config['password'] = conf_app['MONGO_DATABASE_PASSWORD']
      end
    else
      ENV['RAILS_ENV'] ||= 'development'
      config = YAML.load_file("#{Rails.root}/config/database.yml")[ENV['RAILS_ENV']]
    end
    if connect_string
      @connect = PG.connect(connect_string)
    else
      @connect = PG.connect(
        host: 'localhost',
        dbname: config['database'],
        user: config['username'],
        password: config['password']
      )
    end

  end
end