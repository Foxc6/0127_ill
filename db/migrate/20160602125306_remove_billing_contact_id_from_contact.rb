class RemoveBillingContactIdFromContact < ActiveRecord::Migration
  def change
    remove_column :contacts, :billing_contact_id, :integer
  end
end
