class ClientWorkflow < ApplicationWorkflow

  attr_accessor :client

  def initialize(arg ={})
    Rails.logger.debug  "ClientWorkflow.initialize: #{arg.to_json}"
    arg[:client] = (arg[:client][:id] ? Client.find_by_id(arg[:client][:id]) : Client.new(arg[:client])) if arg[:client].class == Hash
    arg[:client] = Client.new if arg[:client].blank?
    update_state({client:arg[:client], company:arg[:company]})
  end

  aasm  do
    state :new, initial:true
    state :not_company
    state :final

    after_all_transitions :log_status_change

    event :update_state, :before=>:update_att do
      transitions :from => :new, :to => :new, guard: :state_is_new
      transitions :from => :new, :to => :not_company, guard: :not_company
      transitions :from => :new, :to => :final,  guard: :final
      transitions :from => :not_company, :to=>:not_company, guard: :not_company
      transitions :from => :not_company, :to => :final, guard: :final
      transitions :from => :final, :to => :final, guard: :final
    end

  end

  def to_slim_json
    {class:self.class.to_s, client:@client.to_short_h}.to_json
  end

  private

  def final
    Rails.logger.debug "&&&------------------------------------------------------------------------------------------------------&&&"
    Rails.logger.debug "&&& to final (@client&.applicant? or (@client&.resp? && @client&.company.present?)) && @client&.persisted?} &&&"
    Rails.logger.debug "&&& to final (#{@client&.applicant?} or (#{@client&.resp?} && #{@client&.company.present?})) && #{@client&.persisted?}} &&&"
    Rails.logger.debug "&&& to final #{(@client&.applicant? or (@client&.resp? && @client&.company.present?)) && @client&.persisted?} &&&"
    Rails.logger.debug "&&&------------------------------------------------------------------------------------------------------&&&"
    (@client&.applicant? or (@client&.resp? && @client&.company.present?)) && @client&.persisted?
  end

  def not_company
    Rails.logger.debug "&&&------------------------------------------------------------------------------------------------------&&&"
    Rails.logger.debug "&&& to not_company @client&.persisted? && @client&.resp? && !@client&.company.present? &&&"
    Rails.logger.debug "&&& to not_company #{@client&.persisted?} && #{@client&.resp?} && #{!@client&.company.present?} &&&"
    Rails.logger.debug "&&& to not_company #{@client&.persisted? && @client&.resp? && !@client&.company.present?} &&&"
    Rails.logger.debug "&&&------------------------------------------------------------------------------------------------------&&&"
    @client&.persisted? && @client&.resp? && !@client&.company.present?
  end

  def state_is_new
    Rails.logger.debug "&&&------------------------------------------------------------------------------------------------------&&&"
    Rails.logger.debug "&&& to state_is_new  =  !((@client&.applicant? or @client&.company.present?) && @client&.persisted?) && !(@client&.persisted? && @client&.resp?) &&&"
    Rails.logger.debug "&&& to state_is_new  =  !((#{@client&.applicant?} or #{@client&.company.present?}) && #{@client&.persisted?}) && !(#{@client&.persisted?} && #{@client&.resp?}) &&&"
    Rails.logger.debug "&&& to state_is_new  = #{ !((@client&.applicant? or @client&.company.present?) && @client&.persisted?) && !(@client&.persisted? && @client&.resp?)} &&&"
    Rails.logger.debug "&&&------------------------------------------------------------------------------------------------------&&&"
    !((@client&.applicant? or @client&.company.present?) && @client&.persisted?) && !(@client&.persisted? && @client&.resp?)
  end

  def update_att(arg = {})
    Rails.logger.debug  "-----ClientWorkflow.update_att: #{arg.to_json}"
    @client =arg[:client] if arg[:client]
    @client.update(company:arg[:company])  if @client&.company.blank? and arg[:company]
  end

end