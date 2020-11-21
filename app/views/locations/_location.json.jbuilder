json.extract! location, :id, :postcode, :suburb, :state, :created_at, :updated_at
json.url location_url(location, format: :json)