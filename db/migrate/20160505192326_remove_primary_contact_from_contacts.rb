class RemovePrimaryContactFromContacts < ActiveRecord::Migration
  def change
  	remove_column :contacts, :primary_contact, :boolean
  end
end
