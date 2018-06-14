class AddContactIdToContactTypes < ActiveRecord::Migration
  def change
    add_reference :contact_types, :contact, index: true
  end
end
