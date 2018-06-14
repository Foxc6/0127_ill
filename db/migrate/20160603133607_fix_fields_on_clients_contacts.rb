class FixFieldsOnClientsContacts < ActiveRecord::Migration
  def change
    change_table :clients_contacts do |t|
      t.rename :client_id_id, :client_id
      t.rename :contact_id_id, :contact_id
    end
  end
end
