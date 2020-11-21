class ResumeDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all
  decorates_association :client
  def keywords
    @keywords ||= "CV, resume online, recrutment, Jobs Galore, Australia, Resumes, Resume, Galore, Jobsgalore,#{object.title}, Talent in #{object.location.name}, Talent, #{object.full_keywords(9).join(", ")}"
  end

  def extras(arg)
    swich = {'1'=>:urgent, '2'=> :top, '3'=> :highlight}
    self.turn swich[arg]
  end

  def url
    h.resume_url(object)
  end

  def path
    h.resume_path(object)
  end

  def turn(extra)
    eval("object.#{extra} ? object.#{extra}_off : object.#{extra}_on")
  end

  def salary
    @salary ||="$"+object.salary.to_i.to_s if object.salary.present? && object.salary!=0
  end



end