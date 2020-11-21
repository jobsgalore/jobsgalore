class ApplicationJob < ActiveJob::Base
  rescue_from ActiveRecord::ConnectionTimeoutError, with: :perform_debug

  def perform_debug
    puts "connectpool size #{ActiveRecord::Base.connection_pool.instance_eval {@size}}"
    puts "connections #{ActiveRecord::Base.connection_pool.instance_eval {@connections}.length}"
    puts "Threads = #{Thread.list.count}"
    Thread.list.each_with_index do |t, i|
      puts "---- trhead #{i}: #{t.inspect}"
      puts t.backtrace.take(5)
    end
    ActiveRecord::Base.connection_pool.clear_reloadable_connections!
  end

end
