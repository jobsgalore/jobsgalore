# Preview all emails at http://localhost:3000/rails/mailers/jobs_mailer/*
class JobsMailerPreview < ActionMailer::Preview

  def add_job
    JobsMailer.add_job(Job.last)
  end

  def daily_job_alert
    JobsMailer.daily_job_alert("mail@email.com", "Ruby web java", 22, nil, nil)
  end

  def daily_job_alert_unsubscribe
    JobsMailer.daily_job_alert("mail@email.com", "Ruby web java", 22, 6, 'Subscribe')
  end

  def daily_job_alert_client
    JobsMailer.daily_job_alert("mail@email.com", "Ruby web java", 22, 6, 'Resume')
  end


  def turn_on_option
    JobsMailer.turn_on_option("Urgent", Job.find_by_id(275320))
  end

  def turn_off_option
    JobsMailer.turn_off_option("Urgent", Job.find_by_id(6965558))
  end

  def notice_remove_job
    JobsMailer.notice_remove_job(2, Job.find_by_id(3399101))
  end

  def remove_job
    JobsMailer.remove_job(Job.find_by_id(3399101))
  end

  def send_job
    JobsMailer.send_job(6965558, "new_email@mail.com")
  end
end