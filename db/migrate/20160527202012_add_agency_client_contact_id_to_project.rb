class AddAgencyClientContactIdToProject < ActiveRecord::Migration
  def change
    add_column :projects, :agency_client_contact_id, :integer
  end
end
