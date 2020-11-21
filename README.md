# Project Jobsgalore

JobsGalore is a job search aggregator in Australia. Find jobs and career related information. Find your dream job. Make job search easy with us!

## Software Requirements

* Ruby and Rails
* Sidekiq
* PostgresSQL
* Redis
* React Js
* Slim

## Installation

    git clone git://github.com/VINichkov/jobsgalore.git
    cd jobsgalore
    bundle install
    
Then initialize the database and start the server:

    rake db:create
    rake db:migrate
    rake db:seed
    rails server

At this point you should have a working site with some basic seed data that you can start to customize.

## License

The MIT License - Copyright (c) 2018 Vyacheslav Nichkov
