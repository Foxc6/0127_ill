class RemoveCountryNameAndStateNameFromAddresses < ActiveRecord::Migration
  def change
  	remove_column :addresses, :state_name, :string
  	remove_column :addresses, :country_name, :string
  end
end
