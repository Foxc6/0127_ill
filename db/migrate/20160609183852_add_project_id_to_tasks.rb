class AddProjectIdToTasks < ActiveRecord::Migration
  def change
  	add_reference :tasks, :project, index: true
  end
end
