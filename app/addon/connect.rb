class Connect
  include Singleton
  attr_accessor :redis
  def initialize
    @redis ||= Redis.new(url: ENV["REDIS_URL"])
  end

end