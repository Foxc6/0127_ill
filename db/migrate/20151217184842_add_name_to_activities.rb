class AddNameToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :name, :string
    add_column :tasks, :name, :string
  end
end
