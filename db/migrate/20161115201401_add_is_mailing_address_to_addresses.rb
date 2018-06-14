class AddIsMailingAddressToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :is_mailing_address, :boolean
  end
end
