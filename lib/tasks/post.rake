namespace :post do
=begin
  desc "Post at Twitter"
  task :twitter => :environment  do
    puts "! Task:Post at Twitter: start"
    if rand(2)==1
      t = Time.now
      e = Time.now.localtime('+10:00')
      if e >Time.parse('07:00 +1000') and e < Time.parse('22:00 +1000')
        companies = Gateway.pluck(:company_id)
        job = Job.where('company_id in (?) and date_trunc(\'day\',created_at)=date(?) and twitter is null',companies,t).all.sample
        if job
          job.post_at_twitter("#{Gateway.find_by_company_id(job.company_id).hashtags} #{job.title}" )
        else
          job = Job.where('(company_id not in (?)) and date_trunc(\'day\',created_at)=date(?) and twitter is null',companies,t).all.sample
          job.post_at_twitter("#{Gateway.find_by_company_id(job.company_id).hashtags} #{job.title}" ) if job
        end
      end
    end
    puts "! Task:Post at Twitter: End"
  end
=end

  task :twitt => :environment  do
    puts "! Task:Post at Twitter: start"
    job = Job.where('location_id in (:location) and created_at >= :date and twitter is null and ((salarymin>=:salary) or (salarymax >= :salary))', date: Time.now - 1.day, location: Location.major.pluck(:id), salary: 150000).all.sample
    if job.present?
      job.post_at_twitter("##{job.location.suburb} #{job.full_keywords(5).map{|t| "#"+t}.join(" ")} #{job.title} #{job.salary}")
    end
    puts "! Task:Post at Twitter: End"
  end


end