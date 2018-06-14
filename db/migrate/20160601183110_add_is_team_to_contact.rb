class AddIsTeamToContact < ActiveRecord::Migration
  def change
    add_column :contacts, :is_team, :boolean
  end
end
