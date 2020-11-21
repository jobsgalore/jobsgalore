require "redis"
class Workflow
  def self.new(arg={})
    switch = LazyHash.new(  ClientWorkflow: ->{ClientWorkflow.new(arg)},
                            JobWorkflow: ->{JobWorkflow.new(arg)},
                            ResumeWorkflow: ->{ResumeWorkflow.new(arg)},
                            Redirect: ->{Redirect.new(arg)})
    switch[arg[:class].to_sym]
  end

  def self.save!(object,session)
    Rails.logger.debug  "!! Workflow.save!: object = #{object.to_json}, session.id #{session}"
    if session.present?
      redis  = connect()
      redis.set(session, object, ex:7200)
    end
  end

  def self.find_by_session(arg)
    Rails.logger.debug  "!! Workflow.find_by_session!: #{arg.to_json}"
    if arg.present?
      redis  = connect()
      response = redis.get(arg)
      if response
        Rails.logger.debug  "!! Workflow.find_by_session!: нашли   #{response}"
        object = JSON.parse(response, opts={symbolize_names:true})
        object ? self.new(object) : false
      else
        Rails.logger.debug  "!! Workflow.find_by_session!: ничего не нашли"
        nil
      end
    end
  end

  def self.delete(arg)
    if arg.present?
      redis  = connect()
      redis.del(arg)
    end
  end

  private
  def self.connect()
    Connect.instance.redis
  end

end