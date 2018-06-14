json.array!(@contacts) do |contact|
  json.extract! contact, :id, :first_name, :last_name, :email, :about, :contact_type_id, :agenda, :wants_general, :wants_specifically, :values, :self_expression_type, :directional_motivation, :time_zone
  json.url contact_url(contact, format: :json)
end
