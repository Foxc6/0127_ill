class AddActivityObjectIdToActivities < ActiveRecord::Migration
  def change
  	add_reference :activities, :activity_object, index: true
  end
end
