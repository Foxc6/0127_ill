class AddBillingContactIdToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :billing_contact_id, :integer
  end
end
