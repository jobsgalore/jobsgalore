class JobWorkflow < ApplicationWorkflow

  attr_accessor :job, :client

  def initialize(arg={})
    Rails.logger.debug  "JobWorkflow.initialize: #{arg.to_json}"
    arg[:client] = (arg[:client][:id] ? Client.find_by_id(arg[:client][:id]) : Client.new(arg[:client])) if arg[:client].class == Hash
    arg[:client] = Client.new if arg[:client].blank?
    arg[:job] = (arg[:job][:id] ? Job.find_by_id(arg[:job][:id]) : Job.new(arg[:job])) if arg[:job].class == Hash
    arg[:job] = Job.new if arg[:job].blank?
    update_state({job:arg[:job], client: arg[:client]})
  end

  aasm  do
    state :new, initial:true
    state :not_persisted
    state :not_company
    state :not_client
    state :final

    after_all_transitions :log_status_change

    event :update_state, :before=>:update_att do
      transitions :from => :new, :to => :new, guard: :state_is_new
      transitions :from => :new, :to => :not_client, guard: :not_client
      transitions :from => :new, :to => :not_company, guard: :not_company
      transitions :from => :new, :to => :not_persisted, guard: :not_persisted
      transitions :from => :new, :to => :final, guard: :final
      transitions :from => :not_client, :to => :not_client, guard: :not_client
      transitions :from => :not_client, :to => :not_company, guard: :not_company
      transitions :from => :not_client, :to => :not_persisted, guard: :not_persisted
      transitions :from => :not_client, :to => :final, guard: :final
      transitions :from => :not_company, :to => :not_persisted, guard: :not_persisted
      transitions :from => :not_company, :to => :final, guard: :final
      transitions :from => :not_persisted, :to => :final, guard: :final
    end
  end

  def to_slim_json
    {class:self.class.to_s, client:@client.to_short_h, job:@job.to_short_h}.to_json
  end

  private
  def state_is_new
    @job.nil?
  end

  def final
    @job.class == Job and @job&.persisted? and @job.company_id? and @job&.client_id?
  end

  def not_persisted
    @job.class == Job and @job&.client_id? and @job.company_id? and !@job.persisted?
  end

  def not_company
    @job.class == Job and @job&.client_id? and !@job.company_id?
  end

  def not_client
    @job.class == Job and !@job&.client_id? and !@job.persisted?
  end

  def update_att(arg = {})
    Rails.logger.debug  "JobWorkflow.update_att: #{arg.to_json}"
    @job =arg[:job] if arg[:job]
    if arg[:client]
      @client =arg[:client]
      @job&.client_id = @client.id if @client.persisted? and !@job&.client_id?
    end
    @job.company_id = @client.company_id if @client&.company_id? and !@job.company_id?
    if !@client&.company_id? and arg[:company]
      @client.update(company:arg[:company], character: TypeOfClient::EMPLOYER)
      @job.company = arg[:company]
    end
  end

end