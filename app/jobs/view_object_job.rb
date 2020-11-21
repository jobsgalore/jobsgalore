class ViewObjectJob < ApplicationJob
  queue_as :default

  def perform(object, arg)
    object.add_viewed(arg)
  end
end
