class InLocations
  include Interactor
  MAX_OBJECT=500
  def count_jobs(location)
    if location.present?
      location.counts_jobs < MAX_OBJECT ? nil : MAX_OBJECT
    else
      MAX_OBJECT
    end
  end

  def call
    @page, @location = context.params[:page], context.params[:location]
    switch = LazyHash.new('1'=>->{company}, '2'=>->{job}, '3'=>->{resume})
    context.page  = @page
    unless switch[context.params[:object]]
      context.fail!
    end
  end

  def company
    loc = Location.find_by_id @location
    context.objs = Company.where(location_id: @location).order(:name).paginate(page: @page, per_page:21, total_entries: count_jobs(loc)).includes(:industry, :location).decorate
    location=loc
    context.name = location.name
    context.query = {type: Objects::COMPANIES.code, value:"", location_id:location.id, location_name:location.name, open:false}
    context.suburb = location.suburb
    context.type = Objects::COMPANIES
    context.key = (['Jobs Galore', 'Australia', 'Job', 'Jobs', 'Galore', 'Jobsgalore', 'Australian Companies', location.name,
            "Companies in #{location.suburb}", "comnany in #{location.suburb}", "career #{location.suburb}",
            "#{location.suburb} employment", "Jobs in #{location.suburb}", "#{location.suburb} job",
            "#{location.suburb} employment", "careers in #{location.suburb}", "in #{location.suburb}",
            "#{location.suburb} #{location.state}"] + context.objs.pluck(:name)).join(', ').squish
    true
  end

  def job
    loc = Location.find_by_id @location
    context.objs = Job.where(location_id: @location).order(created_at: :desc).paginate(page: @page, per_page:25, total_entries: count_jobs(loc)).includes(:company, :location).decorate
    location=loc
    context.name = location.name
    context.query = {type: Objects::JOBS.code, value:"", location_id:location.id, location_name:location.name, open:false}
    context.suburb = location.suburb
    context.type = Objects::JOBS
    context.key = ([
    'Jobs Galore', 'Australia', 'Job', 'Jobs', 'Galore', 'Jobsgalore', location.name, "Jobs in #{location.suburb}",
    "career #{location.suburb}", "#{location.suburb} employment", "Work in #{location.suburb}", "#{location.suburb} job",
    "#{location.suburb} jobs", "#{location.suburb} employment opportunities", "careers in #{location.suburb}",
    "in #{location.suburb}", "job in #{location.suburb}", "#{location.suburb} #{location.state}"] +
    context.objs.pluck(:title)).join(', ').squish
    true
  end

  def resume
    context.objs = Resume.where(location_id: @location).order(created_at: :desc).paginate(page: @page, per_page:25).includes(:location, :client).decorate
    location = context.objs.first&.location || Location.find_by_id(@location)
    context.name = location.name
    context.query = {type: Objects::RESUMES.code, value:"", location_id:location.id, location_name:location.name, open:false}
    context.suburb = location.suburb
    context.type = Objects::RESUMES
    context.key = ([
    'CV', 'resume online', 'recrutment', 'Jobs Galore', 'Australia', 'Job', 'Jobs', 'Galore', 'Jobsgalore', location.name,
   " Resumes in #{location.suburb}", "Talents in #{location.suburb}", "#{location.suburb} career",
    "#{location.suburb} employment", "#{location.suburb} talent", "#{location.suburb} job", "#{location.suburb} employment",
    "careers in #{location.suburb}", "in #{location.suburb}", "#{location.suburb} #{location.state}"] +
    context.objs.pluck(:title).map{|t| t.gsub('|',',')}).uniq.join(', ').squish
    true
  end
end
