class AddDefaultValueToIsTeamOnContacts < ActiveRecord::Migration
  def change
    change_column :contacts, :is_team, :boolean, :default => false
  end
end
