json.extract! @greeting

json.response do
  json.status @status
  json.message @message
  json.greeting @greeting if @greeting.present?
end
