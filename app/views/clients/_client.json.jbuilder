json.extract! client, :id, :firstname, :lastname, :email, :phone, :password, :character, :photo_uid, :gender, :location_id, :created_at, :updated_at
json.url client_url(client, format: :json)