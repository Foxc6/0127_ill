class AddIsClientToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :is_client, :boolean
  end
end
