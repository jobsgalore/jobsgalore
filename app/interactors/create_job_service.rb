class CreateJobService
  include Interactor

  def call
    begin
      context.object = CreateJob.new(context.params)
      if (context.client && context.client.company_id.nil?)
        context.object.is_applicant
      elsif (context.client && context.client.company_id)
        context.object.is_employer
      end
      if result = context.object.save(context.client)
        context.company, context.client, context.job = result.values
        context.msg = 'The job opportunity was successfully created.'
      else
        context.msg = context.object.errors.full_messages
        context.fail!
      end
    rescue
      Rails.logger.info("ERROR #{$!}")
      context.msg = $!
      context.fail!
    end
  end


end
