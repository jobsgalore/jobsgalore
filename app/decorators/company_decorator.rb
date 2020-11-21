class CompanyDecorator < ApplicationDecorator
  delegate_all
  decorates_finders
  decorates_association :job
  decorates_association :client

  def logo_url

    @logo_url ||= if object.logo.blank? || ENV["RAILS_ENV"]!='production'
                    h.image_url("company_profile.jpg")
                  else
                    Dragonfly.app.remote_url_for(object.logo_uid)
                  end
  end

  def jobs_count
    @jobs_count ||= object.job.count
  end

  def keywords
    @keywords ||= "Jobs Galore, Australia, Job, Jobs, Galore, Jobsgalore, #{object.name}, #{object.full_keywords(14).join(", ")}"
  end
end