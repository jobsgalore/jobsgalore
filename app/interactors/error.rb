class Error
  include Interactor

  def call
    context.title = "Latest urgent jobs"
    if context.query && context.query["location_id"].present?
      context.jobs = JobDecorator.decorate_collection(Job.select(:id, :title,:description, :location_id, :company_id, :updated_at).where("location_id = :location and urgent is not null", location: context.query["location_id"]).includes(:location,:company).order(:urgent).last(10))
      if context.jobs.count == 0
        context.jobs = JobDecorator.decorate_collection(Job.select(:id, :title,:description, :location_id, :company_id, :updated_at).where(location_id: context.query["location_id"]).includes(:location,:company).last(10).reverse)
        context.title = "Latest jobs"
      end
    else
      context.jobs = JobDecorator.decorate_collection(Job.select(:id, :title,:description, :location_id, :company_id, :updated_at).where.not(urgent: nil).includes(:location,:company).order(:urgent ).last(10))
      if context.jobs.count == 0
        context.jobs = JobDecorator.decorate_collection(Job.select(:id, :title,:description, :location_id, :company_id, :updated_at).includes(:location,:company).last(10).reverse)
        context.title = "Latest jobs"
      end
    end
    context.city = Location.major
  end

end
