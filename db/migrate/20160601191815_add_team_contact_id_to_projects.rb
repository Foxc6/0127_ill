class AddTeamContactIdToProjects < ActiveRecord::Migration
  def change
  	add_column :projects, :team_contact_id, :boolean
  end
end
