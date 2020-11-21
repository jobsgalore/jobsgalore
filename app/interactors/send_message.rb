class SendMessage
  include Interactor

  def call
    begin
      context.resume = Resume.find_by_id(context.params[:resume])
      send(context.resume, context.params[:text], context.current_client)
      context.msg = 'Your message was successfully sent!'
    rescue
      Rails.logger.debug("ERROR #{$!}")
      context.msg = $!
      context.fail!
    end
  end

  private


  def send(resume, letter, client)
    ResumesMailer.send_message(resume, letter, client).deliver_later
    ResumesMailer.send_message(resume, letter, client, true).deliver_later
  end
end
