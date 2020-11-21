require "#{Rails.root}/lib/tasks/count_jobs/path.rb"

class UpdateNumberOfJobsInLocation
  def call
    sql = <<-SQL
      update locations as l set counts_jobs = q.counts_jobs
      from (select jobs.location_id, count(jobs.location_id) as counts_jobs
            from jobs
            group by jobs.location_id
      ) q
      where l.id = q.location_id;
    SQL
    connect = ConnectPg.new.connect
    connect.exec_params(sql)
  end
end