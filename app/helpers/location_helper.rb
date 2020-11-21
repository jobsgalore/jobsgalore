module LocationHelper
  def link_location(name = nil, location = nil, type= nil, html_options = nil, &block)
    link_to name , local_object_path(location.id,type.code), html_options, &block
  end

end