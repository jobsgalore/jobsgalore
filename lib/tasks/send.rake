namespace :send do

  #(a.close - Time.now.to_date).to_i
  #
  desc "Send daily job alert"
  task :send_deily_job => :environment  do
    puts "! Task:Send daily job alert #{Time.now}"
    DeleteNotUniqClient.new.call

    Resume.find_each do |resume|
      begin
        if resume.client.alert
          JobsMailer.daily_job_alert(
              resume.client.email,
              resume.key,
              resume.location_id,
              resume.client.id,
              'Resume')
              .deliver_now
        end
      rescue
        puts "Error:resume.id =#{resume.id} :#{$!} "
      end
    end

    Clientforalert.find_each do |client|
      begin
        if client.send_email
          JobsMailer.daily_job_alert(
              client.email,
              Search.str_to_search(client.key.delete("<>{}#@!,:*&()'`\"’|")),
              client.location_id,
              client.id,
              'Subscribe')
              .deliver_now
        end
      rescue
        puts "Error:client.email =#{client.email} :#{$!} "
      end
    end
    puts "! Task:Send daily job alert: End #{Time.now}"


  end

  desc "Send invitation to post resume"
  task :send_invate_to_post_resume => :environment do
    puts "! Task:Send invitation to post resume #{Time.now}"
    ClientsForInvate.new.call.each do |email|
      ClientMailer.send_invite_for_posting_resume(email).deliver_now
    end
    puts "! Task:Send invitation to post resume: End #{Time.now}"
  end

end

