class ByCategory
  include Interactor

  def call
    context.category =Industry.all
    switch = {"1"=>Objects::COMPANIES, "2"=> Objects::JOBS, "3"=> Objects::RESUMES}
    context.obj = switch[context.params]
    if context.obj.blank?
      context.fail!
    end
  end
end
