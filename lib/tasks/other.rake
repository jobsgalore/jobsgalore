namespace :other do
  desc "Extras check"
  task :extras_check => :environment  do
    puts "! Task:extras_check: start"
    begin
      db = ActiveRecord::Base.connection
      t = Date.today.to_s
      db.execute("update jobs set highlight=null where highlight+7 < to_date(\'#{t}\',\'YYYY-MM-DD\')")
      db.execute("update jobs set urgent=null where urgent+7 < to_date(\'#{t}\',\'YYYY-MM-DD\')")
      db.execute("update jobs set top=null where top+7 < to_date(\'#{t}\',\'YYYY-MM-DD\')")
      db.execute("update resumes set highlight=null where highlight+7 < to_date(\'#{t}\',\'YYYY-MM-DD\')")
      db.execute("update resumes set urgent=null where urgent+7 < to_date(\'#{t}\',\'YYYY-MM-DD\')")
      db.execute("update resumes set top=null where top+7 < to_date(\'#{t}\',\'YYYY-MM-DD\')")
      Job.where("created_at > :date and fts @@ to_tsquery('english',:value) and urgent is null",{date: Time.now.beginning_of_day - 1.day,value:"urgent"}).update_all(urgent:Time.now)
      a = Job.where("created_at > :date and fts @@ to_tsquery('english',:value)",{date: Time.now.beginning_of_day - 1.day,value:"urgent"})
      (a.count / 2).times do
        a.sample.update(highlight:Time.now)
      end
      Job.where("created_at > :date and highlight is null and (salarymin >= 100000 or salarymax >= 100000)",{date: Time.now.beginning_of_day - 1.day}).update_all(highlight:Time.now)
    rescue
      db.close
      db = nil
      puts "____________________Error: #{$!}"
    end
    puts "! Task:extras_check: End"
  end

  desc "ping to twitter bots"
  task :ping => :environment  do
    #Восстановить.
  end

  task :count_jobs do
    require "#{Rails.root}/lib/tasks/count_jobs/update_number_of_jobs_in_location"
    UpdateNumberOfJobsInLocation.new.call
  end

  task :report => :environment  do
    t = Time.now
    puts "! Task:report: start  #{t}"
    report = {}
    report[:new_resumes] = Resume.where("created_at >= :date", date: Time.now - 1.day).count
    report[:new_jobs] = Job.where("created_at >= :date", date: Time.now - 1.day).count
    report[:new_client_applicants] = Client.where("created_at >= :date and send_email = true and character = 'applicant'", date: Time.now - 1.day).count
    report[:new_client_employers] = Client.where("created_at >= :date and send_email = true and character != 'applicant'", date: Time.now - 1.day).count
    report[:new_client_alert] = Clientforalert.where("created_at >= :date", date: Time.now - 1.day).count
    report[:new_company] = Company.where("created_at >= :date", date: Time.now - 1.day).count
    report[:new_company_description] = Company.where("updated_at >= :date and description is not null", date: Time.now - 1.day).count
    report[:new_pay_count] = Payment.where("created_at >= :date", date: Time.now - 1.day).count
    report[:new_pay_sum] = Payment.where("created_at >= :date and kindpay = 1", date: Time.now - 1.day).count * 10 + Payment.where("created_at >= :date and kindpay = 3", date: Time.now - 1.day).count * 5
    report[:new_viewed_resume] = Viewed.where("created_at >= :date and doc_type = 'Resume'" , date: Time.now - 1.day).count
    report[:new_viewed_job] = Viewed.where("created_at >= :date and doc_type = 'Job'" , date: Time.now - 1.day).count
    report[:new_respondeds] = Responded.where("created_at >= :date" , date: Time.now - 1.day).count
    report[:percent_of_full] = Company.where("description is not null").count.to_f / Company.select('distinct(companies.id)').joins(:job).count.to_f * 100
    report[:amont_of_emails] = EmailHr.where("send_email = true").count + Client.where("send_email = true and character != '#{TypeOfClient::APPLICANT}'").count
    report[:all_mailings] = Mailing.all.count
    report[:expect_of_payment_mailings] = Mailing.where("aasm_state = 'expect_the_payment'").count
    report[:approval_mailings] = Mailing.where("aasm_state = 'approval'").count
    if report[:new_resumes] or report[:new_jobs] or report[:new_client] or report[:new_company] or report[:new_pay_count] or report[:new_pay_sum] or report[:new_viewed]
      ContactUsMailer.alert_of_change(report).deliver_now
    end
    puts "! Task:report: End #{Time.now - t}"
  end

end