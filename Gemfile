source 'https://rubygems.org'

ruby '2.6.3'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails'#, '~> 5.2.0'#, '~> 5.0.4'#, '>= 5.0.0.1'

# Use postgresql as the database for Active Record
gem  'pg', platforms: [:mri, :mingw, :x64_mingw, :truffleruby]#, '~> 0.18'
#gem 'activerecord-jdbcpostgresql-adapter', github: 'jruby/activerecord-jdbc-adapter', platforms: [:jruby]
# Use Puma as the app server
#gem 'sidekiq'

# Use SCSS for stylesheets
gem 'sassc-rails'#, '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'#, '>= 1.3.0'
# Use react as the JavaScript library
gem 'react-rails', '~>2.5.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
#gem "font-awesome-rails"
gem 'redis-objects'
gem 'aasm'
gem 'pdf-reader','~> 2.1.0'
gem 'prawn'
gem 'oga' #Нужен для создания PDF
#gem "oink"
#gem 'pdf2html'
#gem 'origami'
gem "docx"
gem "ffi"
gem "nokogiri", ">= 1.8.5"

gem 'browser' #определяет браузер
gem 'geocoder' #определяет страну
#gem 'typescript-rails' Проблемы. Может позже
gem 'coffee-script'

#gem 'turbolinks'
#gem 'jquery-turbolinks'
#gem 'stimulusjs-rails'

    # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'#, '~> 2.5'
#gem 'jbuilder', github: 'rails/jbuilder', branch: 'master'
#gem "twitter-bootstrap-rails"
gem 'bootstrap-sass'#, '~> 3.3.6'
gem 'sprockets-rails'
gem 'jquery-rails'
gem 'will_paginate'#, '~> 3.1.0'
gem 'cancancan'#, '~> 2.0.0'
gem 'devise','~> 4.7.1'  #4.4.3'
gem 'dkim'
gem 'interactor'
gem 'omniauth-linkedin-oauth2', '~> 1.0.0'
gem 'omniauth-google-oauth2'
gem 'omniauth-facebook'
gem "actionview"#, ">= 5.2.2.1"
gem "activejob"#, ">= 5.2.1.1"
gem "activestorage"#, ">= 5.2.1.1"

gem 'rubyzip'

gem 'twitter'
gem 'will_paginate-bootstrap'# ,'~> 1.0.1'

gem "html_truncator"#, "~>0.4"
gem 'slim'

gem 'dragonfly'#, '~> 1.1.5'
#gem 'mechanize'
gem 'virtus'

#gem "pg_search"#, '~> 2.0.1'
gem 'trix'

# Use Redis adapter to run Action Cable in production
# Use ActiveModel has_secure_password
gem 'bcrypt'#, '~> 3.1.7'
gem 'draper'
gem 'figaro'
# Use Capistrano for deployment




group :development, :test do
  ##############
  #gem 'rack-mini-profiler', require: false
  #gem 'flamegraph'
  #gem 'memory_profiler'
  #gem 'stackprof'
  #gem 'get_process_mem'
  #gem 'derailed_benchmarks'
  ######

  gem 'capistrano',         require: false
  gem 'capistrano-rvm',     require: false
 # gem 'capistrano-sidekiq', require: false
  gem 'capistrano-rails',   require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano3-puma',   require: false
  gem 'capistrano-figaro',   require: false
  gem 'capistrano-rails-console',   require: false
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console

  gem 'byebug', platform: :mri
  gem 'listen'#, '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen'#, '~> 2.0.0'

end
gem 'web-console', group: :development

group :test do
  gem 'simplecov'
  gem 'rspec-rails'
  gem 'rspec-virtus'
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'faker'
end
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
group :production do
  gem 'puma_worker_killer'
  gem 'dragonfly-s3_data_store'
  gem "asset_sync"
  gem "fog-aws"
  gem 'puma', ">= 4.2.1"
end