class CreatePrimaryContacts < ActiveRecord::Migration
  def change
    create_table :primary_contacts do |t|
      t.references :contact, index: :true
      t.references :client, index: :true

      t.timestamps
    end
  end
end
