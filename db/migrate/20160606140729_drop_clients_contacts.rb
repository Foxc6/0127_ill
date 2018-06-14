class DropClientsContacts < ActiveRecord::Migration
  def change
    drop_table :clients_contacts
  end
end
