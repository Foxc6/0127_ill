json.extract! @data

json.response do
  json.status @status
  json.message @message
  json.data @data if @data.present?
end
