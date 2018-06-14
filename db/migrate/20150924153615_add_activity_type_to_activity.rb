class AddActivityTypeToActivity < ActiveRecord::Migration
  def change
    add_reference :activities, :activity_type, index: true
  end
end
