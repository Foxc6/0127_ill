class RemoveInfluenceManagerIdFromActivity < ActiveRecord::Migration
  def change
    remove_reference :activities, :influence_manager, index: true
  end
end
