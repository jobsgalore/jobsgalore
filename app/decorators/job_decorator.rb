class JobDecorator < ApplicationDecorator
  delegate_all
  decorates_association :client
  decorates_association :company

  def keywords
    @keywords ||= "Jobs Galore, Australia, Job, Jobs, Galore, job hunting, Jobsgalore,#{object.title}, Job in #{object.location.name}, Job at #{object.company.name}, #{object.company.name} , Company is #{object.company.name}, , #{object.full_keywords(9).join(", ")}"
  end

  def url
    h.job_url(object)
  end

  def path
    h.job_path(object)
  end

  def extras(arg)
    swich = {'1'=>:urgent, '2'=> :top, '3'=> :highlight}
    self.turn swich[arg]
  end

  def turn(extra)
    eval("object.#{extra} ? object.#{extra}_off : object.#{extra}_on")
    true
  end

end