class AddPrimaryContactIdToProject < ActiveRecord::Migration
  def change
    add_column :projects, :primary_contact_id, :integer
  end
end
