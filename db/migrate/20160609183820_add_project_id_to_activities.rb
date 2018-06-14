class AddProjectIdToActivities < ActiveRecord::Migration
  def change
  	add_reference :activities, :project, index: true
  end
end
