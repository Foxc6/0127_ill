class ChangeClientIdToProjectIdInPrimaryContacts < ActiveRecord::Migration
  def change
    rename_column :primary_contacts, :client_id, :project_id
  end
end
