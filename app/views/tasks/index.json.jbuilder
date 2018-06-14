json.array!(@tasks) do |task|
  json.extract! task, :id, :name, :task_type_id, :user_id, :contact_id, :completed_at
  json.url task_url(task, format: :json)
end
