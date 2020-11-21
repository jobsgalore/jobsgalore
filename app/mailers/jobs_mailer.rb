class JobsMailer < ApplicationMailer

  def add_job(job, copy = nil)
    @utm = create_utm :new_job
    @job = job
    client = (copy ?  PropertsHelper::ADMIN : @job.client.email)
    mail(to:client, subject: "New job opportunity «#{@job.title}» in #{@job.location.name} was just posted on Jobs Galore!")
  end

  def daily_job_alert(email, keys, location_id, unsubscribe = nil, type = nil)
    @utm = "?"+create_utm(:resume_alert)
    @list_of_jobs = Job.includes(:company,:location).search_for_send(value: keys, location:location_id).to_a
    @email = email
    @unsubscribe = unsubscribe
    @type = (type == 'Subscribe')
    if @list_of_jobs.present? and @list_of_jobs.count == 3
      mail(to: @email, subject: "Daily Jobs Alert")
    end
  end

  def turn_on_option(option, job)
    @utm = "?"+create_utm(:turn_on)
    @option, @job = option, job
    mail(to: job.client.email, subject: "The option \"#{option}\" was turned on")
  end

  def turn_off_option(option, job)
    @utm = "?"+create_utm(:turn_off)
    @option, @job = option, job
    mail(to: job.client.email, subject: "The option \"#{option}\" was turned off")
  end

  def notice_remove_job(days, job)
    @utm = "?"+create_utm(:notice_remove_job)
    @days, @job = days, job
    mail(to: job.client.email, subject: "Notification")
  end

  def remove_job(job)
    @utm = "?"+create_utm(:remove_job)
    @job = job
    mail(to: job.client.email, subject: "The job opportunity was just removed")
  end

  def send_job(id, email)
    @utm = "?"+create_utm(:send_job)
    @job = Job.find_by_id id
    @list_of_jobs = @job.similar_vacancies
    mail(to: email, subject: @job.title)
  end


end