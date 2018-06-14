class CreateProjectTeamMembers < ActiveRecord::Migration
  def change
    create_table :project_team_members do |t|
      t.string :name
      t.references :contact, index: true
      t.references :project, index: true

      t.timestamps
    end
  end
end
