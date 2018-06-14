class AddLocaleIdToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :locale_id, :integer
    add_column :tasks, :locale_id, :integer
    add_column :activity_types, :locale_id, :integer
    add_column :task_types, :locale_id, :integer
  end
end
