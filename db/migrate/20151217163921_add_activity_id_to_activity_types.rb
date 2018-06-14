class AddActivityIdToActivityTypes < ActiveRecord::Migration
  def change
    add_reference :activity_types, :activity, index: true
  end
end
