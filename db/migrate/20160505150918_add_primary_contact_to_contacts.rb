class AddPrimaryContactToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :primary_contact, :boolean
  end
end
