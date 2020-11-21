class ApplicationWorkflow
  include AASM

  def save!(session)
    Rails.logger.debug "#{self.class.to_s}.save!: session.id = #{session}"
    Workflow.save!(self.to_slim_json,session)
  end

  private

  def log_status_change
    Rails.logger.debug "Изменения из #{aasm.from_state} в #{aasm.to_state} (event: #{aasm.current_event})"
  end

end
