class CreateClientsContacts < ActiveRecord::Migration
  def change
    create_table :clients_contacts do |t|
      t.string :name
      t.references :client_id, index: true
      t.references :contact_id, index: true

      t.timestamps
    end
  end
end
