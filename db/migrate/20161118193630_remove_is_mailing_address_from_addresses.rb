class RemoveIsMailingAddressFromAddresses < ActiveRecord::Migration
  def change
  	remove_column :addresses, :is_mailing_address, :integer
  end
end
