json.array!(@activities) do |activity|
  json.extract! activity, :id, :name, :note, :activity_type_id, :user_id, :contact_id
  json.url activity_url(activity, format: :json)
end
