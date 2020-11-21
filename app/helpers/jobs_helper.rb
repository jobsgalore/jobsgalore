module JobsHelper
  def salary(object_name, method, options = {})
    options[:type] = 'number'
    content_tag :div, class: "input-group" do
      html = content_tag :span, "$",class: "input-group-addon"
      html += object_name.text_field method, options
    end
  end


  def company_in_jobs(object)
    html = content_tag(:h4, class: "text-center", itemprop:"name"){
      link_to(object.name,object)
    }
    html+= content_tag(:span,object.logo_url, class: "hidden-xs hidden-md hidden-lg hidden-sm",itemprop:"image" )
    html+= image_bg(object.logo_url, "contain", "300px", "250px", autoload: false )
  end

  def last_job(job)
    html='<li>'+
            '<hr/>'+
            "<p>#{link_to(job.title, job)}</p>"+
            "<span class='small'>#{link_to(job.company.name, job.company, class: 'text-success')}</span>"+
            '&nbsp; - &nbsp;'+
            "<span class='small'>#{link_location(job.location.name, job.location, Objects::JOBS, class: 'text-warning')}</span>"+
          '</li>'
    html.html_safe
  end

  def meta_for_jobs(job)
    meta_head({ description: job.description_meta,
                  title: job.title,
                  keywords: job.keywords,
                  url: job_url(job),
                  canonical: job_url(job),
                  image: job.company.logo_url,
                  published: job.updated_at,
                  card: 'summary_large_image',
                  user: 'jobsGalore_AU'})
  end

  def meta_for_new_job
    meta_head({
                title: 'Post Job Ads for Free | JobsGalore',
                keywords: 'Jobs Galore, work, job, vacancy search, resume, jobs, Australia, vacancies, employment,'\
                          'looking for a job, search, seek, galore, money, solary, indeed, JobsGalore,'\
                          'jobs in university, post job free, post jobs for free, look for job, seeking, job board,'\
                          'Post Job Ads for Free'
              }
    )
  end

  def similar_vacancies(job )
    react_component("Loader", url_similar_for_job: similar_jobs_url(job))
  end

  def social_button(job)
    social_share_button_tag(job.title,
                            url: job_url(job),
                            desc:job.description_text,
                            text_in_window: 'Email this job to yourself or a friend',
                            post_url: send_job_path,
                            params: {job: job.id}.to_json
    )
  end

end
