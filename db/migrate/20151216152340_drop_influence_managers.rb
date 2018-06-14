class DropInfluenceManagers < ActiveRecord::Migration
  def change
    drop_table :influence_managers
  end
end
