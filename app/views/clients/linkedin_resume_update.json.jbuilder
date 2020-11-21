if @response
  json.extract! @response, :title, :industry_id, :location_id, :location_name, :description
end