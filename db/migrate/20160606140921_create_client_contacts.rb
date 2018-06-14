class CreateClientContacts < ActiveRecord::Migration
  def change
    create_table :client_contacts do |t|
      t.string :name
      t.references :contact, index: true
      t.references :client, index: true
    end
  end
end
